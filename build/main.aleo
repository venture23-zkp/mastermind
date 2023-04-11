program mastermindI.aleo;

struct secret:
    first as u8;
    second as u8;
    third as u8;
    blinding_factor as field;

struct game:
    id as field;
    started as boolean;
    finished as boolean;

struct guess:
    first as u8;
    second as u8;
    third as u8;

struct player:
    addr as address;
    secret_hash as field;

record move:
    owner as address.private;
    gates as u64.private;
    game as game.private;
    player_1 as player.private;
    player_2 as player.private;
    guess as guess.private;
    hits as u8.private;
    blows as u8.private;

mapping games:
	key left as field.public;
	value right as u8.public;
function offer_game:
    input r0 as field.private;
    input r1 as secret.private;
    input r2 as address.private;
    lt r1.first 5u8 into r3;
    lt r1.second 5u8 into r4;
    and r3 r4 into r5;
    lt r1.third 5u8 into r6;
    and r5 r6 into r7;
    assert.eq r7 true;
    is.neq r1.first r1.second into r8;
    is.neq r1.second r1.third into r9;
    and r8 r9 into r10;
    is.neq r1.third r1.first into r11;
    and r10 r11 into r12;
    assert.eq r12 true;
    cast 5u8 5u8 5u8 into r13 as guess;
    cast r0 false false into r14 as game;
    hash.bhp256 r1 into r15;
    cast self.caller r15 into r16 as player;
    cast r2 0u64 r14 r16 r16 r13 0u8 0u8 into r17 as move.record;
    output r17 as move.record;

    finalize r0;

finalize offer_game:
    input r0 as field.public;
    increment games[r0] by 255u8;

function accept_game:
    input r0 as move.record;
    input r1 as secret.private;
    not r0.game.started into r2;
    assert.eq r2 true;
    lt r1.first 5u8 into r3;
    lt r1.second 5u8 into r4;
    and r3 r4 into r5;
    lt r1.third 5u8 into r6;
    and r5 r6 into r7;
    assert.eq r7 true;
    is.neq r1.first r1.second into r8;
    is.neq r1.second r1.third into r9;
    and r8 r9 into r10;
    is.neq r1.third r1.first into r11;
    and r10 r11 into r12;
    assert.eq r12 true;
    hash.bhp256 r1 into r13;
    cast self.caller r13 into r14 as player;
    cast r0.player_1.addr 0u64 r0.game r0.player_1 r14 r0.guess 0u8 0u8 into r15 as move.record;
    output r15 as move.record;

function start_game:
    input r0 as move.record;
    input r1 as guess.private;
    not r0.game.started into r2;
    assert.eq r2 true;
    assert.neq r0.player_1.addr r0.player_2.addr;
    cast r0.game.id true false into r3 as game;
    cast r0.player_2.addr 0u64 r3 r0.player_1 r0.player_2 r1 0u8 0u8 into r4 as move.record;
    output r4 as move.record;

closure calculate_hits:
    input r0 as guess;
    input r1 as secret;
    is.eq r1.first r0.first into r2;
    add 0u8 1u8 into r3;
    ternary r2 r3 0u8 into r4;
    is.eq r1.second r0.second into r5;
    add r4 1u8 into r6;
    ternary r5 r6 r4 into r7;
    is.eq r1.third r0.third into r8;
    add r7 1u8 into r9;
    ternary r8 r9 r7 into r10;
    output r10 as u8;

closure calculate_blows:
    input r0 as guess;
    input r1 as secret;
    is.eq r0.first r1.second into r2;
    is.eq r0.first r1.third into r3;
    or r2 r3 into r4;
    add 0u8 1u8 into r5;
    ternary r4 r5 0u8 into r6;
    is.eq r0.second r1.first into r7;
    is.eq r0.second r1.third into r8;
    or r7 r8 into r9;
    add r6 1u8 into r10;
    ternary r9 r10 r6 into r11;
    is.eq r0.third r1.first into r12;
    is.eq r0.third r1.second into r13;
    or r12 r13 into r14;
    add r11 1u8 into r15;
    ternary r14 r15 r11 into r16;
    output r16 as u8;

function play:
    input r0 as move.record;
    input r1 as secret.private;
    input r2 as guess.private;
    assert.eq r0.game.started true;
    hash.bhp256 r1 into r3;
    assert.eq r0.player_2.secret_hash r3;
    call calculate_hits r0.guess r1 into r4;
    call calculate_blows r0.guess r1 into r5;
    cast r0.player_1.addr 0u64 r0.game r0.player_2 r0.player_1 r2 r4 r5 into r6 as move.record;
    output r6 as move.record;
