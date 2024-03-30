# Step 1: Encode the data (e.g., JSON) into a format suitable for Solana (e.g., base64)
encoded_data=$(echo '{"example_field": "example_value"}' | base64)

# Step 2: Determine the account address where you want to store the data
account_address="BPxh3RiUfrSwe8kdKYAbfGAVfq4LWW5cjtyXXn1xRUCQ"

# Step 3: Create a transaction with an instruction to write the data to the specified account
sudo solana tx write \
    --url https://api.devnet.solana.com \
    --keypair ./BPxh3RiUfrSwe8kdKYAbfGAVfq4LWW5cjtyXXn1xRUCQ.json \
    --instructions '[
        {
            "accounts": [
                {
                    "pubkey": "'$account_address'",
                    "isWritable": true,
                    "isSigner": false
                }
            ],
            "data": "'$encoded_data'",
            "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
        }
    ]'

