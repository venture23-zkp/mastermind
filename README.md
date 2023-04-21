# Mastermind Game in Aleo

# Summary
MastermindI is a modified version of [classic mastermind game](https://en.wikipedia.org/wiki/Mastermind_(board_game)) where players compete to be the first to crack the code and open a lock box, using hints to guess the correct combination of three digits ranging from 1 to 5.

## How to build
To compile this Leo program, run:
```bash
leo build
```

## How to Play

### 0. Initializing the Players
In order to play mastermind, there must be two players with their own secrets that they have set for their opponent. Players will be represented by their Aleo address. You can use the provided player accounts or [generate your own](https://github.com/aleoHQ/aleo/#31-generate-a-new-aleo-account).

```markdown
Player 1 (P1):
  Private Key  APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
     View Key  AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6
      Address  aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

Player 2 (P2):
  Private Key  APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
     View Key  AViewKey1hh6dvSEgeMdfseP4hfdbNYjX4grETwCuTbKnCftkpMwE
      Address  aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
```
Save the keys and addresses. To execute the transition as P1, we have to set private key, view key and address in the of P1 in `program.json` as follows:

```json
{
    "program": "mastermindI.aleo",
    "version": "0.0.0",
    "description": "Play Mastermind",
    "development": {
        "private_key": "APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm",
        "view_key": "AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6",
        "address": "aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy"
    },
    "license": "MIT"
}
```

Again to execute transition as P2, we have to set the keys of P2 in `program.json` as follows:

```json
{
    "program": "mastermindI.aleo",
    "version": "0.0.0",
    "description": "Play Mastermind",
    "development": {
        "private_key": "APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm",
        "view_key": "AViewKey1fSyEPXxfPFVgjL6qcM9izWRGrhSHKXyN3c64BNsAjnA6",
        "address": "aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy"
    },
    "license": "MIT"
}
```
To simplifiy things, we have created [load_P1()](https://github.com/prajwolrg/mastermind/blob/main/run.sh#L22) and [load_P2()](https://github.com/prajwolrg/mastermind/blob/main/run.sh#L36) functions that handles this switching between players in `program.json`.

### 1. Player 1 Offers Challenge to Player 2

First, Player 1 needs to think of a challenge combination to offer to player 2.
With the combination in mind, Player 1 can challenge Player 2.
Let's set the secret to `1-2-3` and `blinding_factor` to 1.

> In actual game, blinding factor is a large random number.

**Run**
```
P1_SECRET='{first: 1u8, second: 2u8, third: 3u8, blinding_factor: 1field}' 
leo run offer_game "${GAME_ID}" "${P1_SECRET}" "${P2_ADDR}"
```

**Inputs**
* GAME_ID is used to uniquely identify the game.
* P1_SECRET is a defined as a `secret` struct:
     ```
     struct secret {
        first: u8,
        second: u8, 
        third: u8,
        blinding_factor: field,
    }
    ```
* P2_ADDR is the address of the opponent P1 wants to challenge

We have limited the secret to the combination of three digits between 1 and 5. Since there is only a few combination, adversary may bruteforce through these to calculate the hash directly. To prevent this we have introduced the `blinding_factor` in the `secret`.

**Output**
```bash
➡️  Output

 • {
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
  _nonce: 1820731671035474072612759968384267468381307900941538344954362882614616593008group.public
}

Leo ✅ Executed 'mastermindI.aleo/offer_game'

```
Notice that the owner of the output record is P2, yet, we have set both players to the as P1. We set player_2 as P2 only after P2 has accepted the game offer. 
Also, since there is no guess included, the guess has been set to 5-5-5 since this is an invalid guess (valid digits: 0-4) and is just a dummy guess. Similarly, hits and blows are both 0.

### 2: P2 Accepts The Game
On recieving the game, P2 has two choices: 
* Ignore the game offer
* Accept the game offer
> We could have added a third choice, in which P2 could have rejected the offer. But rejecting offer will add overhead (proof generation and transaction cost) on P2 which might not make sense.

To accept the offer P2 can run `leo run accept_game 'offer_move.record' P2_SECRET` with the record P1 had created for P2. Let's set P2 secret to 0-4-3.
**Run**
```
P2_SECRET='{first: 0u8, second: 4u8, third: 3u8, blinding_factor: 1field}' 
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
}' "${P2_SECRET}"
```

**Output**
```bash
➡️  Output

 • {
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
  _nonce: 598953930398798284486982868041802868368192398524343250365566432132317794919group.public
}

Leo ✅ Executed 'mastermindI.aleo/accept_game' 
```
Now that P2 has accepted the game, only now player_1 is not same as player_2. P1 is now able to start the game by making the first guess.

### 3: P1 Starts The Game By Making A First Guess
P1 makes the first guess as 1-2-3 by running `leo run play 'move.record' 'P1_FIRST_GUESS'`

**Run**
```bash
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
}' "${P1_FIRST_GUESS}"
```

**Output**
```bash
➡️  Output

 • {
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
  _nonce: 6320783691355520315123864815731760025989783041248512995993333478226656173461group.public
}

Leo ✅ Executed 'mastermindI.aleo/start_game'
```
> Notice that the game: started is now true.

### 4: P2 plays the game by making the first guess
Now, P2 can play the game by making the first guess as 1-2-3. Run `leo run play 'move.record' 'P2_SECRET' 'P2_FIRST_GUESS'`:
**Run**
```bash
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
```

**Outputs**
```bash
➡️  Output

 • {
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
  _nonce: 4177857604129712866141049920372327240371870585773118922817285705846350050452group.public
}

Leo ✅ Executed 'mastermindI.aleo/play' 
```

### 4: P1 plays the game by making the second guess
Now, P1 can play the game by making the second guess.
Again, P2 makes the second guess
P1 makes the third guess
Again, P2 makes the third guess and so on...

### 5. Who Wins?
Play continues back and forth between Player 1 and Player 2.
When one player has a total of 14 flipped bits in their `hits_and_misses` component on their `board_state` record,
they have won the game.

## Ensure that each player can only move once before the next player can move

A move record must be consumed in order to create the next move record. The owner of the move record changes with each play. Player A must spend a move record in order to create a move record containing their guesses, and that move record will be owned by Player B. Player B must spend that move record in order to create the next move record, which will belong to Player A.

## Enforce constraints on valid moves, and force the player to give their opponent information about their opponent's previous move in order to continue playing

In order to give their next move to their opponent, a player must call the `main.leo/play` function, which takes the input as player's secret and opponent's guess from the move. The move record being created is then updated with the number of hits and blows for the opponent.

## Winning the game

Right now, the way to check when a game has been won is to count the check `hits` and `blows` component. Once you have 3 hits, you've won the game.