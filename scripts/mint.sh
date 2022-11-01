#!/bin/bash

NODE="https://rpc.euphoria.aura.network:443"
ACCOUNT="my-first-wallet"
CHAINID="euphoria-1"
CONTRACT_DIR="artifacts/cw20_token.wasm"
SLEEP_TIME="15s"

CW20_TOKEN_ADDR="aura16kf53x8kywy6l3hd7tlde0knmnqyhx3ckemcvl0lfsgmuwfehl7sxw5lzf"
AMOUNT_WITHOUT_DENOM="$1"

MINT="{\"mint\": {\"recipient\":\"$ACCOUNT\", \"amount\":\"$AMOUNT_WITHOUT_DENOM\"}}"
echo $SEND_NFT

RES=$(aurad tx wasm execute "$CW20_TOKEN_ADDR" "$MINT" --from "$ACCOUNT" -y --output json --chain-id "$CHAINID" --node "$NODE" --gas 35000000 --fees 35000ueaura -y --output json)
echo $RES

TXHASH=$(echo $RES | jq -r .txhash)
echo $TXHASH

# sleep for chain to update
sleep "$SLEEP_TIME"

RAW_LOG=$(aurad query tx "$TXHASH" --chain-id "$CHAINID" --node "$NODE" -o json | jq -r .raw_log)

echo $RAW_LOG