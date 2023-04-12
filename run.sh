
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# Follow along in the README.md for a detailed explanation of each step.

P1_SECRET='{first: 1u8, second: 2u8, third: 3u8, blinding_factor: 1field}' 
P2_SECRET='{first: 0u8, second: 4u8, third: 3u8, blinding_factor: 1field}' 

echo "
###############################################################################
########                                                               ########
########         STEP 1: P1 creates game and offers to P2              ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"mastermindII.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json


# leo run offer_game 1field '{first: 1u8, second: 2u8, third: 3u8, blinding_factor: 1field}' aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
leo run offer_game 1field 1u8 2u8 3u8 1field aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
echo "
✅ Successfully offered game to Player 2."

echo "
###############################################################################
########                                                               ########
########           STEP 2: P2 accepts the game                         ########
########                                                               ########
###############################################################################
"
(
  echo "{
    \"program\": \"mastermindII.aleo\",
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

leo run accept_game '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  game: {
    id: 1field.private,
    started: false.private,
    finished: false.private
  },
  player_1: {
    addr: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
    secret_hash: 4150411142742965853031818295656888588698558427018459831715669006349479301277field.private
  },
  player_2: {
    addr: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
    secret_hash: 4150411142742965853031818295656888588698558427018459831715669006349479301277field.private
  },
  guess: {
    first: 5u8.private,
    second: 5u8.private,
    third: 5u8.private
  },
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 4304234582584161222006203195424646986785902330183375426776730527878554918531group.public
}' 0u8 4u8 3u8 1field

# 3: 
echo "
###############################################################################
########                                                               ########
########         STEP 3: Player 1 Starts The Game                      ########
########                                                               ########
###############################################################################
"

echo "{
  \"program\": \"mastermindII.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

P1_FIRST_GUESS='{first: 1u8, second: 2u8, third: 3u8}'
leo run start_game '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  game: {
    id: 1field.private,
    started: false.private,
    finished: false.private
  },
  player_1: {
    addr: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
    secret_hash: 4150411142742965853031818295656888588698558427018459831715669006349479301277field.private
  },
  player_2: {
    addr: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
    secret_hash: 7408027298759572436229032800668706857653653501832695599177141981492741491812field.private
  },
  guess: {
    first: 5u8.private,
    second: 5u8.private,
    third: 5u8.private
  },
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 187399225973057883148804049741506250315462706455897819382681563165650211777group.public
}' 1u8 2u8 3u8


echo "
###############################################################################
########                                                               ########
########      STEP 4: P2 process P1 guess and makes own guess          ########
########                                                               ########
###############################################################################
"
(
  echo "{
    \"program\": \"mastermindII.aleo\",
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

P2_FIRST_GUESS='{first: 1u8, second: 2u8, third: 3u8}'
leo run play '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  gates: 0u64.private,
  game: {
    id: 1field.private,
    started: true.private,
    finished: false.private
  },
  player_1: {
    addr: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
    secret_hash: 4150411142742965853031818295656888588698558427018459831715669006349479301277field.private
  },
  player_2: {
    addr: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
    secret_hash: 7408027298759572436229032800668706857653653501832695599177141981492741491812field.private
  },
  guess: {
    first: 1u8.private,
    second: 2u8.private,
    third: 3u8.private
  },
  hits: 0u8.private,
  blows: 0u8.private,
  _nonce: 8149421582681812140272606675585073498037110677768117426632245107863646891256group.public
}' 0u8 4u8 3u8 1field 1u8 2u8 3u8


echo "
###############################################################################
########                                                               ########
########         P1 process P2 guess and makes own guess               ########
########                                                               ########
###############################################################################
"

echo "{
  \"program\": \"mastermindII.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm\",
      \"view_key\": \"AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6\",
      \"address\": \"aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy\"
  },
  \"license\": \"MIT\"
}" > program.json

P1_SECOND_GUESS='{first: 1u8, second: 2u8, third: 3u8}'
leo run play '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  gates: 0u64.private,
  game: {
    id: 1field.private,
    started: true.private,
    finished: false.private
  },
  player_1: {
    addr: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
    secret_hash: 7408027298759572436229032800668706857653653501832695599177141981492741491812field.private
  },
  player_2: {
    addr: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
    secret_hash: 4150411142742965853031818295656888588698558427018459831715669006349479301277field.private
  },
  guess: {
    first: 1u8.private,
    second: 2u8.private,
    third: 3u8.private
  },
  hits: 1u8.private,
  blows: 0u8.private,
  _nonce: 6582567456528561440640155374621523804008146339198881355721086796346177531539group.public
}' 1u8 2u8 3u8 1field 1u8 2u8 3u8
