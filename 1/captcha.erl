-module(captcha).

-export([ c_one/1
        , c_two/1
        , c_three/1
        , f_to_l/1
        , s_to_l/1
        , one/1
        , two/1
        ]).

one(Filename) -> c_one(f_to_l(Filename)).
two(Filename) -> c_three(f_to_l(Filename)).

c_to_i($0) -> 0;
c_to_i($1) -> 1;
c_to_i($2) -> 2;
c_to_i($3) -> 3;
c_to_i($4) -> 4;
c_to_i($5) -> 5;
c_to_i($6) -> 6;
c_to_i($7) -> 7;
c_to_i($8) -> 8;
c_to_i($9) -> 9.

f_to_l(F) ->
  {ok, Bin} = file:read_file(F),
  [ c_to_i(C) || <<C>> <= Bin, C >= 48, C < 58].

s_to_l(S) ->
  lists:map(fun c_to_i/1, S).

c_one([H | _] = L) ->
  c_one(L, H, 0).

c_one([H | []], H, S) -> S + H;
c_one([_ | []], _, S) -> S;
c_one([H | [H | _] = T], O, S) -> c_one(T, O, S + H);
c_one([_ | [_ | _] = T], O, S) -> c_one(T, O, S).

c_two(L) ->
  c_two(L, length(L), length(L) div 2 + 1).

c_two(L, M, N) ->
  c_two(L ++ lists:sublist(L, N), M, N, 0).

c_two(_, 0, _, S) -> S;
c_two([H|T] = L, M, N, S) ->
  case H =:= lists:nth(N, L) of
    true -> c_two(T, M - 1, N, S + H);
    false -> c_two(T, M - 1, N, S)
  end.

c_three(L) -> c_three(lists:split(length(L) div 2, L), 0).
c_three({L1, L2}, S) -> c_three(L1, L2, S) + c_three(L2, L1, S).
c_three([     ], [     ], S) -> S;
c_three([H1|T1], [H1|T2], S) -> c_three(T1, T2, S + H1);
c_three([ _|T1], [ _|T2], S) -> c_three(T1, T2, S).
