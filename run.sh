#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# Follow along in the README.md for a detailed explanation of each step.

echo "
###############################################################################
########                                                               ########
########         STEP 1: P1 creates game and offers to P2              ########
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

leo run offer_game 1u8 1u8 1u8 1u8 aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
echo "
✅ Successfully offered game to Player 2."

# ➡️  Outputs

#  • {
#   owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   gates: 0u64.private,
#   first: 1u8.private,
#   second: 1u8.private,
#   third: 1u8.private,
#   fourth: 1u8.private,
#   opponent: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   game_started: false.private,
#   _nonce: 5624583346723341206072874082179292434877103367679538456659849909205856100551group.public
# }
#  • {
#   owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   gates: 0u64.private,
#   player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   first_guess: 0u8.private,
#   second_guess: 0u8.private,
#   third_guess: 0u8.private,
#   fourth_guess: 0u8.private,
#   hits: 0u8.private,
#   blows: 0u8.private,
#   _nonce: 93365508995123373653560929585509199651315961415610069179259121093085594948group.public
# }

echo "
###############################################################################
########                                                               ########
########           STEP 2: P2 accepts the game                         ########
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

leo run accept_game 2u8 2u8 2u8 2u8  '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  first_guess: 0u8.private,
  second_guess: 0u8.private,
  third_guess: 0u8.private,
  fourth_guess: 0u8.private,
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 4543595979323260588863872986883490867199425290780589981546381751679071088350group.public
}'
echo "
✅ Successfully accepted game by Player 2."

# Outputs
#  • {
#   owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   gates: 0u64.private,
#   first: 2u8.private,
#   second: 2u8.private,
#   third: 2u8.private,
#   fourth: 2u8.private,
#   opponent: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   game_started: true.private,
#   _nonce: 1950369996900848819814366571733164109314560868636410071976472994761288656494group.public
# }
#  • {
#   owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   gates: 0u64.private,
#   player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   first_guess: 0u8.private,
#   second_guess: 0u8.private,
#   third_guess: 0u8.private,
#   fourth_guess: 0u8.private,
#   hits: 0u8.private,
#   blows: 0u8.private,
#   _nonce: 565893079494208453276353669213481425143141010668720104239563007465780376962group.public
# }

# 3: 
echo "
###############################################################################
########                                                               ########
########         STEP 3: Player 1 Starts The Game                      ########
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

leo run start_game '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  first: 1u8.private,
  second: 1u8.private,
  third: 1u8.private,
  fourth: 1u8.private,
  opponent: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: false.private,
  _nonce: 5624583346723341206072874082179292434877103367679538456659849909205856100551group.public
}' '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  first_guess: 0u8.private,
  second_guess: 0u8.private,
  third_guess: 0u8.private,
  fourth_guess: 0u8.private,
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 565893079494208453276353669213481425143141010668720104239563007465780376962group.public
}' 1u8 2u8 3u8 4u8

# ➡️  Outputs

#  • {
#   owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   gates: 0u64.private,
#   first: 1u8.private,
#   second: 1u8.private,
#   third: 1u8.private,
#   fourth: 1u8.private,
#   opponent: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   game_started: true.private,
#   _nonce: 219973862463187739090360824152788226790560497439569710185986962483561304161group.public
# }
#  • {
#   owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   gates: 0u64.private,
#   player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
#   player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
#   first_guess: 1u8.private,
#   second_guess: 2u8.private,
#   third_guess: 3u8.private,
#   fourth_guess: 4u8.private,
#   hits: 0u8.private,
#   blows: 0u8.private,
#   _nonce: 962846019303673287743144493974234715238574087657253014548054142989626868661group.public
# }


echo "
###############################################################################
########                                                               ########
########      STEP 2: P2 process P1 guess and makes own guess          ########
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

leo run play '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  first_guess: 1u8.private,
  second_guess: 2u8.private,
  third_guess: 3u8.private,
  fourth_guess: 4u8.private,
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 5943239244508193061445223177014442598152417263283932873329593873721165511261group.public
}' '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  first: 2u8.private,
  second: 2u8.private,
  third: 2u8.private,
  fourth: 2u8.private,
  opponent: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: true.private,
  _nonce: 1950369996900848819814366571733164109314560868636410071976472994761288656494group.public
}' 1u8 2u8 3u8 4u8


echo "
###############################################################################
########                                                               ########
########         P1 process P2 guess and makes own guess               ########
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

leo run play '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  first_guess: 1u8.private,
  second_guess: 2u8.private,
  third_guess: 3u8.private,
  fourth_guess: 4u8.private,
  hits: 1u8.private,
  blows: 1u8.private,
  _nonce: 6129908657243639195443441174134187228343973122836747396753633348100386927986group.public
}' '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  first: 1u8.private,
  second: 1u8.private,
  third: 1u8.private,
  fourth: 1u8.private,
  opponent: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: true.private,
  _nonce: 219973862463187739090360824152788226790560497439569710185986962483561304161group.public
}' 1u8 2u8 3u8 4u8