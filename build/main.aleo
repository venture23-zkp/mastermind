program mastermind.aleo;

record secret:
    owner as address.private;
    gates as u64.private;
    first as u8.private;
    second as u8.private;
    third as u8.private;
    fourth as u8.private;
    opponent as address.private;
    game_started as boolean.private;

record move:
    owner as address.private;
    gates as u64.private;
    player_1 as address.private;
    player_2 as address.private;
    first_guess as u8.private;
    second_guess as u8.private;
    third_guess as u8.private;
    fourth_guess as u8.private;
    hits as u8.private;
    blows as u8.private;

function offer_game:
    input r0 as u8.private;
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as address.private;
    cast self.caller 0u64 r0 r1 r2 r3 r4 false into r5 as secret.record;
    cast r4 0u64 self.caller self.caller 0u8 0u8 0u8 0u8 0u8 0u8 into r6 as move.record;
    output r5 as secret.record;
    output r6 as move.record;

function accept_game:
    input r0 as u8.private;
    input r1 as u8.private;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as move.record;
    cast self.caller 0u64 r0 r1 r2 r3 r4.player_1 true into r5 as secret.record;
    cast r4.player_1 0u64 r4.player_1 self.caller 0u8 0u8 0u8 0u8 0u8 0u8 into r6 as move.record;
    output r5 as secret.record;
    output r6 as move.record;

function start_game:
    input r0 as secret.record;
    input r1 as move.record;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as u8.private;
    input r5 as u8.private;
    assert.eq r0.game_started false;
    assert.eq r0.opponent r1.player_2;
    assert.neq r1.player_1 r1.player_2;
    cast self.caller 0u64 r0.first r0.second r0.third r0.fourth r1.player_2 true into r6 as secret.record;
    cast r1.player_2 0u64 r1.player_1 r1.player_2 r2 r3 r4 r5 0u8 0u8 into r7 as move.record;
    output r6 as secret.record;
    output r7 as move.record;

closure calculate_hits:
    input r0 as move.record;
    input r1 as secret.record;
    is.eq r1.first r0.first_guess into r2;
    add 0u8 1u8 into r3;
    ternary r2 r3 0u8 into r4;
    is.eq r1.second r0.second_guess into r5;
    add r4 1u8 into r6;
    ternary r5 r6 r4 into r7;
    is.eq r1.third r0.third_guess into r8;
    add r7 1u8 into r9;
    ternary r8 r9 r7 into r10;
    is.eq r1.fourth r0.fourth_guess into r11;
    add r10 1u8 into r12;
    ternary r11 r12 r10 into r13;
    output r13 as u8;

closure calculate_blows:
    input r0 as move.record;
    input r1 as secret.record;
    is.eq r0.first_guess r1.second into r2;
    is.eq r0.first_guess r1.third into r3;
    or r2 r3 into r4;
    is.eq r0.first_guess r1.fourth into r5;
    or r4 r5 into r6;
    add 0u8 1u8 into r7;
    ternary r6 r7 0u8 into r8;
    is.eq r0.second_guess r1.first into r9;
    is.eq r0.second_guess r1.third into r10;
    or r9 r10 into r11;
    is.eq r0.second_guess r1.fourth into r12;
    or r11 r12 into r13;
    add r8 1u8 into r14;
    ternary r13 r14 r8 into r15;
    is.eq r0.third_guess r1.first into r16;
    is.eq r0.third_guess r1.second into r17;
    or r16 r17 into r18;
    is.eq r0.third_guess r1.fourth into r19;
    or r18 r19 into r20;
    add r15 1u8 into r21;
    ternary r20 r21 r15 into r22;
    is.eq r0.fourth_guess r1.first into r23;
    is.eq r0.third_guess r1.second into r24;
    or r23 r24 into r25;
    is.eq r0.third_guess r1.third into r26;
    or r25 r26 into r27;
    add r22 1u8 into r28;
    ternary r27 r28 r22 into r29;
    output r29 as u8;

function play:
    input r0 as move.record;
    input r1 as secret.record;
    input r2 as u8.private;
    input r3 as u8.private;
    input r4 as u8.private;
    input r5 as u8.private;
    assert.eq r1.game_started true;
    call calculate_hits r0 r1 into r6;
    call calculate_blows r0 r1 into r7;
    cast r0.player_1 0u64 self.caller r0.player_1 r2 r3 r4 r5 r6 r7 into r8 as move.record;
    cast self.caller 0u64 r1.first r1.second r1.third r1.fourth r1.opponent true into r9 as secret.record;
    output r8 as move.record;
    output r9 as secret.record;
