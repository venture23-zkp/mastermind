// The 'mastermind' program.
program mastermindII.aleo {

    struct secret {
        first: u8,
        second: u8, 
        third: u8,
        blinding_factor: field,
    }

    struct game {
        id: field,
        started: bool,
        finished: bool
    }

    struct guess {
        first: u8,
        second: u8,
        third: u8
    }

    struct player {
        addr: address,
        secret_hash: field,
    }

    record move {
        owner: address,
        gates: u64,
        game: game,
        player_1: player,
        player_2: player,
        guess: guess,
        hits: u8,
        blows: u8
    }

    mapping games: field => u8;

    transition offer_game(game_id: field, first: u8, second: u8, third: u8, blinding_factor: field, opponent: address) -> move {

        // let firstLessThanFive: bool = first < 5u8;
        // assert(firstLessThanFive);
        // let secondLessThanFive: bool = second < 5u8;
        // assert(secondLessThanFive);
        // let thirdLessThanFive: bool = third < 5u8;
        // assert(secondLessThanFive);

        assert(first < 5u8 && second < 5u8 && third < 5u8);
        assert(first != second && second != third && third != first);
        
        let starting_guess: guess = guess {
            first: 5u8,
            second: 5u8,
            third: 5u8
        };

        let new_game: game = game {
            id: game_id,
            started: false,
            finished: false
        };

        let new_secret: secret = secret {
            first,
            second,
            third,
            blinding_factor
        };

        let player_1: player = player {
            addr: self.caller,
            secret_hash: BHP256::hash(new_secret)
        };

        let offer_move: move = move {
            owner: opponent,
            gates: 0u64,
            game: new_game,
            player_1,
            player_2: player_1,
            guess: starting_guess,
            hits: 0u8,
            blows: 0u8
        };

        return offer_move then finalize(game_id);
    }

    finalize offer_game(game_id: field) {
        increment(games, game_id, 255u8);
    }

    transition accept_game(offer_move: move, first: u8, second: u8, third: u8, blinding_factor: field) -> move {

        assert( !offer_move.game.started );

        assert(first < 5u8 && second < 5u8 && third < 5u8);
        assert(first != second && second != third && third != first);

        let new_secret: secret = secret {
            first,
            second,
            third,
            blinding_factor
        };
        
        let player_2: player = player {
            addr: self.caller,
            secret_hash: BHP256::hash(new_secret)
        };

        let accept_move: move = move {
            owner: offer_move.player_1.addr,
            gates: 0u64,
            game: offer_move.game,
            player_1: offer_move.player_1,
            player_2,
            guess: offer_move.guess,
            hits: 0u8,
            blows: 0u8
        };

        return accept_move;
    }

    transition start_game(accept_move: move, first_guess: u8, second_guess: u8, third_guess: u8) -> move {
        assert(!accept_move.game.started);
        assert_neq(accept_move.player_1.addr, accept_move.player_2.addr);

        let struct_start_game: game = game {
            id: accept_move.game.id,
            started: true,
            finished: false
        };

        let my_guess: guess = guess {
            first: first_guess,
            second: second_guess,
            third: third_guess
        };

        let start_move: move = move {
            owner: accept_move.player_2.addr,
            gates: 0u64,
            game: struct_start_game,
            player_1: accept_move.player_1,
            player_2: accept_move.player_2,
            guess: my_guess,
            hits: 0u8,
            blows: 0u8
        };

        return start_move;
    }

    function calculate_hits(opponent_guess: guess, my_secret: secret) -> u8 {
        let hits: u8 = 0u8;
        if my_secret.first == opponent_guess.first {
            hits += 1u8;
        }
        if my_secret.second == opponent_guess.second {
            hits += 1u8;
        }
        if my_secret.third == opponent_guess.third {
            hits += 1u8;
        }
        return hits;
    }

    function calculate_blows(opponent_guess: guess, my_secret: secret) -> u8 {
        let blows: u8 = 0u8;
        if opponent_guess.first == my_secret.second || opponent_guess.first == my_secret.third {
            blows += 1u8;
        }
        if opponent_guess.second == my_secret.first || opponent_guess.second == my_secret.third {
            blows += 1u8;
        }
        if opponent_guess.third == my_secret.first || opponent_guess.third == my_secret.second {
            blows += 1u8;
        }
        return blows;
    }

    transition play(opponent_move: move, first_secret: u8, second_secret: u8, third_secret: u8, blinding_factor: field, first_guess: u8, second_guess: u8, third_guess: u8) -> move {
        assert(opponent_move.game.started);

        let my_secret: secret = secret {
            first: first_secret,
            second: second_secret,
            third: third_secret,
            blinding_factor: blinding_factor
        };

        assert_eq(opponent_move.player_2.secret_hash, BHP256::hash(my_secret));

        let my_guess: guess = guess {
            first: first_guess,
            second: second_guess,
            third: third_guess
        };

        let hits: u8 = calculate_hits(opponent_move.guess, my_secret);
        let blows: u8 = calculate_blows(opponent_move.guess, my_secret);

        return move {
            owner: opponent_move.player_1.addr,
            gates: 0u64,
            game: opponent_move.game,
            player_1: opponent_move.player_2,
            player_2: opponent_move.player_1,
            guess: my_guess,
            hits,
            blows
        };

    }

}
