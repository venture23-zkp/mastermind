// The 'mastermind' program.
program mastermind.aleo {

    record secret {
        owner: address,
        gates: u64,
        first: u8,
        second: u8,
        third: u8,
        fourth: u8,
        opponent: address,
        game_started: bool
    }

    record move {
        owner: address,
        gates: u64,
        player_1: address,
        player_2: address,
        first_guess: u8,
        second_guess: u8,
        third_guess: u8,
        fourth_guess: u8,
        hits: u8,
        blows: u8
    }

    transition offer_game(first: u8, second: u8, third: u8, fourth: u8, opponent: address) -> (secret, move) {
        let new_secret: secret = secret{
            owner: self.caller,
            gates: 0u64,
            first,
            second,
            third,
            fourth,
            opponent,
            game_started: false
        };

        let offer_move: move = move {
            owner: opponent,
            gates: 0u64,
            player_1: self.caller,
            player_2: self.caller,
            first_guess: 0u8,
            second_guess: 0u8,
            third_guess: 0u8,
            fourth_guess: 0u8,
            hits: 0u8,
            blows: 0u8
        };

        return (new_secret, offer_move);
    }

    transition accept_game(first: u8, second: u8, third: u8, fourth: u8, offer_move: move) -> (secret, move) {
        let new_secret: secret = secret{
            owner: self.caller,
            gates: 0u64,
            first,
            second,
            third,
            fourth,
            opponent: offer_move.player_1,
            game_started: true,
        };

        let accept_move: move = move {
            owner: offer_move.player_1,
            gates: 0u64,
            player_1: offer_move.player_1,
            player_2: self.caller,
            first_guess: 0u8,
            second_guess: 0u8,
            third_guess: 0u8,
            fourth_guess: 0u8,
            hits: 0u8,
            blows: 0u8
        };

        return (new_secret, accept_move);
    }

    transition start_game(my_secret: secret, accept_move: move, first_guess: u8, second_guess: u8, third_guess: u8, fourth_guess: u8) -> (secret, move) {

        assert_eq(my_secret.game_started, false);
        assert_eq(my_secret.opponent, accept_move.player_2);
        assert_neq(accept_move.player_1, accept_move.player_2);

        let updated_secret: secret = secret{
            owner: self.caller,
            gates: 0u64,
            first: my_secret.first,
            second: my_secret.second,
            third: my_secret.third,
            fourth: my_secret.fourth,
            opponent: accept_move.player_2,
            game_started: true
        };

        let start_move: move = move {
            owner: accept_move.player_2,
            gates: 0u64,
            player_1: accept_move.player_1,
            player_2: accept_move.player_2,
            first_guess,
            second_guess,
            third_guess,
            fourth_guess,
            hits: 0u8,
            blows: 0u8
        };

        return (updated_secret, start_move);
    }


    function calculate_hits(opponent_move: move, my_secret: secret) -> u8 {
        let hits: u8 = 0u8;
        if my_secret.first == opponent_move.first_guess {
            hits += 1u8;
        }
        if my_secret.second == opponent_move.second_guess {
            hits += 1u8;
        }
        if my_secret.third == opponent_move.third_guess {
            hits += 1u8;
        }
        if my_secret.fourth == opponent_move.fourth_guess {
            hits += 1u8;
        }
        return hits;
    }

    function calculate_blows(opponent_move: move, my_secret: secret) -> u8 {
        let blows: u8 = 0u8;
        if opponent_move.first_guess == my_secret.second || opponent_move.first_guess == my_secret.third || opponent_move.first_guess == my_secret.fourth {
            blows += 1u8;
        }
        if opponent_move.second_guess == my_secret.first || opponent_move.second_guess == my_secret.third || opponent_move.second_guess == my_secret.fourth {
            blows += 1u8;
        }
        if opponent_move.third_guess == my_secret.first || opponent_move.third_guess == my_secret.second || opponent_move.third_guess == my_secret.fourth {
            blows += 1u8;
        }
        if opponent_move.fourth_guess == my_secret.first || opponent_move.third_guess == my_secret.second || opponent_move.third_guess == my_secret.third {
            blows += 1u8;
        }
        return blows;
    }

    transition play(opponent_move: move, my_secret: secret, first_guess: u8, second_guess: u8, third_guess: u8, fourth_guess: u8) -> (move, secret) {

        assert_eq(my_secret.game_started, true);

        let hits: u8 = calculate_hits(opponent_move, my_secret);
        let blows: u8 = calculate_blows(opponent_move, my_secret);

        let new_move: move = move{
            owner: opponent_move.player_1,
            gates: 0u64,
            player_1: self.caller,
            player_2: opponent_move.player_1,
            first_guess,
            second_guess,
            third_guess,
            fourth_guess,
            hits,
            blows
        };

        let my_unconsumed_secret: secret = secret{
            owner: self.caller,
            gates: 0u64,
            first: my_secret.first,
            second: my_secret.second,
            third: my_secret.third,
            fourth: my_secret.fourth,
            opponent: my_secret.opponent,
            game_started: true
        };

        return (new_move, my_unconsumed_secret);
    }
}
