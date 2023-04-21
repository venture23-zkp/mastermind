P1_ADDR=aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt
P1_VIEW_KEY = AViewKey1e9ghrdh1aFpFXdKtwUB7SNzb718iJ3ETT9qbKN6oKivj
P1_PRIVATE_KEY=APrivateKey1zkpDSP5ht8fz2YzJpPgMWwSbdk6sChDgWq59i2UQrZY12UZ

P2_ADDR=aleo15we7tsgynhhk54m6ukas8yt4m0l5ekr5am0qqsh7uv6xv3q5zczqeacpqj
P2_VIEW_KEY = AViewKey1jKR25A5kooBmr2NUs3ALgY7rcHRfDJwtFHS8nq4AZffX
P2_PRIVATE_KEY=APrivateKey1zkpJJKtKREYhk9KVYmQPaNjmiGc1LJ8YcUyEgisBd3SoRH8


###############################################################################
########                                                               ########
########         STEP 1: P1 creates game and offers to P2              ########
########                                                               ########
###############################################################################

# snarkos developer execute mastermindII.aleo offer_game \
# 1918111field 1u8 2u8 3u8 80992167048825730000field "${P2_ADDR}" \
# --private-key "${P1_PRIVATE_KEY}" \
# --query "https://vm.aleo.org/api" \
# --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \

# ✅ Successfully broadcast execution 'mastermindII.aleo/offer_game' to the https://vm.aleo.org/api/testnet3/transaction/broadcast.
# at1vskh8qr6q359vy4gufzcmjn2t4g7r0wvv7n5xhhygc3j5wnrdvyq2eaay5
# Explorer URL: https://explorer.hamp.app/transaction?id=at1vskh8qr6q359vy4gufzcmjn2t4g7r0wvv7n5xhhygc3j5wnrdvyq2eaay5


###############################################################################
########                                                               ########
########           STEP 2: P2 accepts the game                         ########
########                                                               ########
###############################################################################

# P2 accepts the game
# snarkos developer execute mastermindII.aleo accept_game \
# "{owner: aleo15we7tsgynhhk54m6ukas8yt4m0l5ekr5am0qqsh7uv6xv3q5zczqeacpqj.private, gates: 0u64.private, game: { id: 1918111field.private, started: false.private, finished: false.private }, player_1: { addr: aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt.private, secret_hash: 3792252545144875704152637708661979615583107214933006046420696268468523697170field.private }, player_2: { addr: aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt.private, secret_hash: 3792252545144875704152637708661979615583107214933006046420696268468523697170field.private }, guess: { first: 5u8.private, second: 5u8.private, third: 5u8.private }, hits: 0u8.private, blows: 0u8.private, _nonce: 745231638738312374696040275947184047207537987565450309584079091371162121487group.public}" 0u8 4u8 3u8 1field \
# --private-key "${P2_PRIVATE_KEY}" \
# --query "https://vm.aleo.org/api" \
# --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" 

# ✅ Successfully broadcast execution 'mastermindII.aleo/accept_game' to the https://vm.aleo.org/api/testnet3/transaction/broadcast.
# at1j0vnecqee2m742z5qjec86eeqnwqw8tgrcvd562t540fzd2psvpqffq6pq
# Explorer URL: https://explorer.hamp.app/transaction?id=at1j0vnecqee2m742z5qjec86eeqnwqw8tgrcvd562t540fzd2psvpqffq6pq

###############################################################################
########                                                               ########
########         STEP 3: Player 1 Starts The Game                      ########
########                                                               ########
###############################################################################

#P1 makes a guess '243' starts the game
# snarkos developer execute mastermindII.aleo start_game \
# "{ owner: aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt.private, gates: 0u64.private, game: { id: 1918111field.private, started: false.private, finished: false.private }, player_1: { addr: aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt.private, secret_hash: 3792252545144875704152637708661979615583107214933006046420696268468523697170field.private }, player_2: { addr: aleo15we7tsgynhhk54m6ukas8yt4m0l5ekr5am0qqsh7uv6xv3q5zczqeacpqj.private, secret_hash: 7408027298759572436229032800668706857653653501832695599177141981492741491812field.private }, guess: { first: 5u8.private, second: 5u8.private, third: 5u8.private }, hits: 0u8.private, blows: 0u8.private, _nonce: 5731342482724660281688914037551108681560250186509881614519362847505803740798group.public}" \
# 2u8 4u8 3u8 \
# --private-key "${P1_PRIVATE_KEY}" \
# --query "https://vm.aleo.org/api" \
# --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" 

# ✅ Successfully broadcast execution 'mastermindII.aleo/start_game' to the https://vm.aleo.org/api/testnet3/transaction/broadcast.
# at1df0p4w695j8khmprhhqrphftnmh8tql7sz55yfk478u9ktw6yvpsxfu6qj
# Explorer URL: https://explorer.hamp.app/transaction?id=at1df0p4w695j8khmprhhqrphftnmh8tql7sz55yfk478u9ktw6yvpsxfu6qj


###############################################################################
########                                                               ########
########      STEP 4: P2 process P1 guess and makes own guess          ########
########                                                               ########
###############################################################################

# snarkos developer execute mastermindII.aleo play \
# "{ owner: aleo15we7tsgynhhk54m6ukas8yt4m0l5ekr5am0qqsh7uv6xv3q5zczqeacpqj.private, gates: 0u64.private, game: { id: 1918111field.private, started: true.private, finished: false.private }, player_1: { addr: aleo1tru5wyf4knxcstwzm6zflv0r5lz0s2fqgk7yfh3c934g04l09qgqnxs4tt.private, secret_hash: 3792252545144875704152637708661979615583107214933006046420696268468523697170field.private }, player_2: { addr: aleo15we7tsgynhhk54m6ukas8yt4m0l5ekr5am0qqsh7uv6xv3q5zczqeacpqj.private, secret_hash: 7408027298759572436229032800668706857653653501832695599177141981492741491812field.private }, guess: { first: 1u8.private, second: 2u8.private, third: 3u8.private }, hits: 0u8.private, blows: 0u8.private, _nonce: 7273982965348108353264661815199648297426733901468453672152459784852668478841group.public}" \
# 0u8 4u8 3u8 1field \
# 2u8 1u8 4u8 \
# --private-key "${P2_PRIVATE_KEY}" \
# --query "https://vm.aleo.org/api" \
# --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" 

# ✅ Successfully broadcast execution 'mastermindII.aleo/play' to the https://vm.aleo.org/api/testnet3/transaction/broadcast.
# at1hwtaj9xlujrremn0fqpxupx77g8r7hr8rt8aq0aujye8lwk73vps6n6290
# Explorer URL: https://explorer.hamp.app/transaction?id=at1hwtaj9xlujrremn0fqpxupx77g8r7hr8rt8aq0aujye8lwk73vps6n6290