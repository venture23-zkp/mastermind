#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# Follow along in the README.md for a detailed explanation of each step.

# 1: Initializing Player 1 
echo "
###############################################################################
########                                                               ########
########                 STEP 1: Initializing Player 1                 ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"mastermind.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

echo "✅ Successfully initialized Player 1."

# 2: Player 1 Create a game and offers it to player 2
echo "
###############################################################################
########                                                               ########
########           STEP 2: Player 1 creates a new game and offers it   ########
########                                                               ########
###############################################################################
"
leo run offer_game 1u8 1u8 1u8 1u8 aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry

echo "
✅ Successfully initialized Player 1's board."

# 3: 
echo "
###############################################################################
########                                                               ########
########         STEP 3: Player 1 Passes The Board To Player 2         ########
########                                                               ########
###############################################################################
"
(
  echo "{
    \"program\": \"mastermind.aleo\",
    \"version\": \"0.0.0\",
    \"description\": \"\",
    \"development\": {
        \"private_key\": \"APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH\",
        \"view_key\": \"AViewKey1hh6dvSEgeMdfseP4hfdbNYjX4grETwCuTbKnCftkpMwE\",
        \"address\": \"aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry\"
    },
    \"license\": \"MIT\"
  }" > program.json
)
echo "
✅ Successfully initialized Player 2's board."
"
leo run accept_game 2u8 2u8 2u8 2u8  '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  player_1: aleo1ud3f9qknpy5apexkwhz9l7j2yx2k0plcptz8ml22yqg2m0pfngysgy3rjd.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  first_guess: 0u8.private,
  second_guess: 0u8.private,
  third_guess: 0u8.private,
  fourth_guess: 0u8.private,
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 6380051947539106434779892545518212919534381180371058714942062142466058896309group.public
}'
echo "
✅ Successfully passed the board to Player 2."
