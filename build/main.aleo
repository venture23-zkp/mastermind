program mastermindII.aleo;

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
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as field.private;
    input r5 as address.private;
    lt r1 5u8 into r6;
    lt r2 5u8 into r7;
    and r6 r7 into r8;
    lt r3 5u8 into r9;
    and r8 r9 into r10;
    assert.eq r10 true;
    is.neq r1 r2 into r11;
    is.neq r2 r3 into r12;
    and r11 r12 into r13;
    is.neq r3 r1 into r14;
    and r13 r14 into r15;
    assert.eq r15 true;
    cast 5u8 5u8 5u8 into r16 as guess;
    cast r0 false false into r17 as game;
    cast r1 r2 r3 r4 into r18 as secret;
    hash.bhp256 r18 into r19;
    cast self.caller r19 into r20 as player;
    cast r5 0u64 r17 r20 r20 r16 0u8 0u8 into r21 as move.record;
    output r21 as move.record;

    finalize r0;

finalize offer_game:
    input r0 as field.public;
    increment games[r0] by 255u8;

function accept_game:
    input r0 as move.record;
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as field.private;
    not r0.game.started into r5;
    assert.eq r5 true;
    lt r1 5u8 into r6;
    lt r2 5u8 into r7;
    and r6 r7 into r8;
    lt r3 5u8 into r9;
    and r8 r9 into r10;
    assert.eq r10 true;
    is.neq r1 r2 into r11;
    is.neq r2 r3 into r12;
    and r11 r12 into r13;
    is.neq r3 r1 into r14;
    and r13 r14 into r15;
    assert.eq r15 true;
    cast r1 r2 r3 r4 into r16 as secret;
    hash.bhp256 r16 into r17;
    cast self.caller r17 into r18 as player;
    cast r0.player_1.addr 0u64 r0.game r0.player_1 r18 r0.guess 0u8 0u8 into r19 as move.record;
    output r19 as move.record;

function start_game:
    input r0 as move.record;
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    not r0.game.started into r4;
    assert.eq r4 true;
    assert.neq r0.player_1.addr r0.player_2.addr;
    cast r0.game.id true false into r5 as game;
    cast r1 r2 r3 into r6 as guess;
    cast r0.player_2.addr 0u64 r5 r0.player_1 r0.player_2 r6 0u8 0u8 into r7 as move.record;
    output r7 as move.record;

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
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as field.private;
    input r5 as u8.private;
    input r6 as u8.private;
    input r7 as u8.private;
    assert.eq r0.game.started true;
    cast r1 r2 r3 r4 into r8 as secret;
    hash.bhp256 r8 into r9;
    assert.eq r0.player_2.secret_hash r9;
    cast r5 r6 r7 into r10 as guess;
    call calculate_hits r0.guess r8 into r11;
    call calculate_blows r0.guess r8 into r12;
    cast r0.player_1.addr 0u64 r0.game r0.player_2 r0.player_1 r10 r11 r12 into r13 as move.record;
    output r13 as move.record;
