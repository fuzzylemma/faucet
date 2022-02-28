include secrets.make

FUJI=https://api.avax-test.network/ext/bc/C/rpc

deploy:
	forge create --rpc-url ${FUJI} --private-key ${PRIVATE_KEY} src/Faucet.sol:Faucet
