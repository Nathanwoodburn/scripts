import json
import requests
import os
import sys
import argparse
import getpass

# Try to get HSD_API_KEY from environment variable
HSD_API_KEY = os.environ.get("HSD_API_KEY")
if HSD_API_KEY is None:
    raise Exception("Please set HSD_API_KEY environment variable")

days_until_expire = 180

wallet_list = ["cold","hot","registry","greg","hnsau","renewservice"]

def get_domains(key,wallet):
    url = f"http://x:{key}@127.0.0.1:12039/wallet/{wallet}/name?own=true" 
    response = requests.get(url)
    if response.status_code != 200:
        return []
    
    # Check if the response is valid JSON
    try:
        response.json()
    except json.decoder.JSONDecodeError:
        return []

    return response.json()


def domains_expiring_soon(key,wallet,silent=False):
    domains = get_domains(key,wallet)
    expiring = []
    for domain in domains:
        days_left = domain["stats"]["daysUntilExpire"]
        if days_left < days_until_expire:
            if not silent:
                print(f"{domain['name']} expires in {days_left} days")
            expiring.append(domain["name"])
            
    if len(expiring) > 0:
        with open(f"/tmp/domains_expiring_soon_{wallet}.txt", "w") as f:
            for domain in expiring:
                f.write(f"{domain}\n")
    return expiring

if __name__ == "__main__":
    # optional args --wallet <wallet> --days <days> --api_key <api_key>
    parser = argparse.ArgumentParser(description='Check HSD domains for expiration')
    parser.add_argument('--wallet', help='Wallet to check', default="all")
    parser.add_argument('--days', help='Days until expiration', default=180)
    parser.add_argument('--api_key', help='API key', default=HSD_API_KEY)
    parser.add_argument('--renew', help='Renew domains', action='store_true')
    args = parser.parse_args()

    

    HSD_API_KEY = args.api_key
    days_until_expire = args.days
    # Try to convert days_until_expire to an integer
    try:
        days_until_expire = int(days_until_expire)
    except ValueError:
        print("Invalid days_until_expire value")
        sys.exit(1)


    wallets = args.wallet
    if wallets == "all":
        wallets = wallet_list
    else:
        wallets = [wallets]

    for wallet in wallets:
        print(f"Checking {wallet} wallet...")
        domains_expiring_soon(HSD_API_KEY,wallet)

    if args.renew:
        print("Renewing domains...")
        for wallet in wallets:
            domains = domains_expiring_soon(HSD_API_KEY,wallet,silent=True)
            if len(domains) > 0:
                print(f"Renewing {len(domains)} domains for {wallet} wallet...")
                batch = []
                for domain in domains:
                    batch.append(f'["RENEW", "{domain}"]')

                batchTX = "[" + ", ".join(batch) + "]"
                reqcontent = f'{{"method": "sendbatch","params":[ {batchTX} ]}}'

                # Select wallet
                response = requests.post(f'http://x:{HSD_API_KEY}@127.0.0.1:12039', data='{"method": "selectwallet","params": [ "'+wallet+'" ]}')
                if response.status_code != 200:
                    print(f"Error selecting wallet {wallet}: {response.text}")
                    continue
                
                # Ask user for password
                password = getpass.getpass(prompt=f"Enter password for wallet {wallet}: ")
                if password != "":
                    response = requests.post(f'http://x:{HSD_API_KEY}@127.0.0.1:12039', data='{"method": "walletpassphrase","params": [ "'+password+'", 300 ]}')
                    if response.status_code != 200:
                        print(f"Error setting password for wallet {wallet}: {response.text}")
                        continue

                response = requests.post(f'http://x:{HSD_API_KEY}@127.0.0.1:12039', data=reqcontent)
            
                if response.status_code != 200:
                    print(f"Error renewing domains for wallet {wallet}: {response.text}")
                    continue
                
                output = response.json()
                if "error" in output:
                    if output["error"]:
                        print(f"Error renewing domains for wallet {wallet}: {output['error']}")

                print("TX: " + output["result"]["hash"])


