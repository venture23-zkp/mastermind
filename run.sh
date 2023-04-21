
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

P1_ADDR=aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy
P1_VIEW_KEY=AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6
P1_PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm

P2_ADDR=aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
P2_VIEW_KEY=AViewKey1hh6dvSEgeMdfseP4hfdbNYjX4grETwCuTbKnCftkpMwE
P2_PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH

P1_SECRET='{first: 1u8, second: 2u8, third: 3u8, blinding_factor: 1field}' 
P2_SECRET='{first: 0u8, second: 4u8, third: 3u8, blinding_factor: 1field}' 

GAME_ID='1field'

load_P1() {
  echo "{
    \"program\": \"mastermindI.aleo\",
    \"version\": \"0.0.0\",
    \"description\": \"\",
    \"development\": {
        \"private_key\": \"${P1_PRIVATE_KEY}\",
        \"view_key\": \"${P1_VIEW_KEY}\",
        \"address\": \"${P1_ADDR}\"
    },
    \"license\": \"MIT\"
  }" > program.json
}

load_P2() {
  echo "{
    \"program\": \"mastermindI.aleo\",
    \"version\": \"0.0.0\",
    \"description\": \"\",
    \"development\": {
        \"private_key\": \"${P2_PRIVATE_KEY}\",
        \"view_key\": \"${P2_VIEW_KEY}\",
        \"address\": \"${P2_ADDR}\"
    },
    \"license\": \"MIT\"
  }" > program.json
}

#########################################################

echo "STEP 1: P1 creates a game and offers to P2
"
load_P1
leo run offer_game "${GAME_ID}" "${P1_SECRET}" "${P2_ADDR}" > outputs/offer_game.move

echo "
✅ Success: Game Offered. Game Status:
###############################################################################
########                                                               ########
########         SECRETS:: P1: 1-2-3                                   ########
########                                                               ########
###############################################################################
"

#########################################################

echo " STEP 2: P2 accepts the game "
load_P2
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
}' "${P2_SECRET}" > outputs/accept_game.move

echo "
✅ Success: Game Accepted. Game Status:
###############################################################################
########                                                               ########
########         SECRETS:: P1: 1-2-3                                   ########
########                   P2: 0-4-3                                   ########
########                                                               ########
###############################################################################
"

#########################################################

echo " STEP 3: P1 starts the game "
load_P1
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
}' "${P1_FIRST_GUESS}" > outputs/start_game.move

echo "
✅ Success: Game Started. Game Status:
###############################################################################
########                                                               ########
########         SECRETS:: P1: 1-2-3                                   ########
########                   P2: 0-4-3                                   ########
########                                                               ########
########         GUESSES:: P1: 1-2-3                                   ########
########                                                               ########
###############################################################################
"

#########################################################

echo " STEP 4: P2 process P1 guess and makes own guess "
load_P2
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
}' "${P2_SECRET}" "${P2_FIRST_GUESS}" > outputs/play1.move

echo "
✅ Success: Playing Game. Game Status
###############################################################################
########                                                               ########
########         SECRETS:: P1: 1-2-3                                   ########
########                   P2: 0-4-3                                   ########
########                                                               ########
########         GUESSES:: P1: 1-2-3 -> Hits:1 Blows:0                 ########
########                                                               ########
########                   P2: 1-2-3                                   ########
########                                                               ########
###############################################################################
"

#########################################################

echo " STEP 5: P1 process P2 guess and makes own guess "
P1_SECOND_GUESS='{first: 1u8, second: 2u8, third: 3u8}'
load_P1
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
}' "${P1_SECRET}"  "${P1_SECOND_GUESS}" > outputs/play2.move

echo "
✅ Success: Playing Game. Game Status:
###############################################################################
########                                                               ########
########         SECRETS:: P1: 1-2-3                                   ########
########                   P2: 0-4-3                                   ########
########                                                               ########
########         GUESSES:: P1: 1-2-3 -> Hits:1 Blows:0                 ########
########                                                               ########
########                   P2: 1-2-3 -> Hits:3 Blows:0                 ########
########                                                               ########
###############################################################################
"