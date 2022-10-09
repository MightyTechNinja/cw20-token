#!/bin/bash

NODE="https://rpc.euphoria.aura.network:443"
ACCOUNT="my-first-wallet"
CHAINID="euphoria-1"
CONTRACT_DIR="artifacts/cw20_factory_token.wasm"
SLEEP_TIME="15s"

CODE_ID="$1"

INIT="{\"name\":\"Aura Test Token\", \"symbol\":\"ATT\", \"decimals\":18, \"initial_balances\": [{\"amount\":\"123000\", \"address\":\"$(aurad keys show $ACCOUNT -a)\"}]}"
INIT_JSON=$(aurad tx wasm instantiate "$CODE_ID" "$INIT" --from "$ACCOUNT" --label "cw20-factory-token" -y --chain-id "$CHAINID" --node "$NODE" --no-admin --gas 180000 --fees 35000ueaura -o json)

echo "INIT_JSON = $INIT_JSON"

if [ "$(echo $INIT_JSON | jq -r .raw_log)" != "[]" ]; then
	# exit
	echo "ERROR = $(echo $INIT_JSON | jq .raw_log)"
	exit 1
else
	echo "INSTANTIATE SUCCESS"
fi

# sleep for chain to update
sleep "$SLEEP_TIME"

RAW_LOG=$(aurad query tx "$(echo $INIT_JSON | jq -r .txhash)" --chain-id "$CHAINID" --node "$NODE" --output json | jq -r .raw_log)

echo "RAW_LOG = $RAW_LOG"

CONTRACT_ADDRESS=$(echo $RAW_LOG | jq -r .[0].events[0].attributes[0].value)

echo "CONTRACT ADDRESS = $CONTRACT_ADDRESS"

