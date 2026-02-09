% ==========================================
% Sovereign AI Router - Logic Core
% File: routing_rules.pl
% ==========================================

:- use_module(library(lists)).

% ------------------------------------------
% 1. TAXONOMY & FACTS
% ------------------------------------------

% Domain Definitions
domain_type(coding_architecture).
domain_type(coding_implementation).
domain_type(reasoning).
domain_type(creative).
domain_type(documentation).
domain_type(unknown).

% Domain Keywords
keywords(coding_architecture, [refactor, architecture, design, pattern, microservice, interface, dependency, structure, system]).
keywords(coding_implementation, [implement, function, script, bug, fix, debug, optimize, loop, variable, class]).
keywords(reasoning, [analyze, evaluate, plan, strategy, compare, tradeoff, logic, why, how]).
keywords(creative, [story, poem, narrative, style, tone, blog, creative, write]).
keywords(documentation, [document, readme, guide, manual, explain, summary, spec, scan, pdf, extract, ocr]).

% Complexity Indicators (Score 1-3)
complexity_indicator(refactor, 3).
complexity_indicator(architecture, 3).
complexity_indicator(system, 3).
complexity_indicator(optimize, 2).
complexity_indicator(debug, 2).
complexity_indicator(simple, 1).
complexity_indicator(draft, 1).

% Risk Indicators (Score 1-3)
risk_indicator(production, 3).
risk_indicator(security, 3).
risk_indicator(payment, 3).
risk_indicator(database, 2).
risk_indicator(api, 2).

% Model Capabilities (Proficiency 0.0 - 1.0)
model_proficiency(qwen_coder_32b, coding_architecture, 0.95).
model_proficiency(qwen_coder_32b, coding_implementation, 0.85).
model_proficiency(nemotron_30b, coding_implementation, 0.95).
model_proficiency(gpt_oss_20b, reasoning, 0.90).
model_proficiency(mythomax_13b, creative, 0.95).
% Default fallback for documentation/unknown
model_proficiency(gpt_oss_20b, documentation, 0.80).
model_proficiency(gpt_oss_20b, unknown, 0.50).

% ------------------------------------------
% 2. HELPER PREDICATES
% ------------------------------------------

% Count matching keywords in a list of tokens
count_matches([], _, 0).
count_matches([Token|Rest], Keywords, Count) :-
    member(Token, Keywords),
    count_matches(Rest, Keywords, SubCount),
    Count is SubCount + 1.
count_matches([Token|Rest], Keywords, Count) :-
    \+ member(Token, Keywords),
    count_matches(Rest, Keywords, Count).

% ------------------------------------------
% 3. CORE POLICIES
% ------------------------------------------

% --- Domain Classification Policy ---
% Rule: Match if >= 2 keywords found. Order matters (Architecture > Implementation).
classify_domain(Tokens, coding_architecture) :-
    keywords(coding_architecture, KWs), count_matches(Tokens, KWs, C), C >= 2, !.
classify_domain(Tokens, coding_implementation) :-
    keywords(coding_implementation, KWs), count_matches(Tokens, KWs, C), C >= 2, !.
classify_domain(Tokens, reasoning) :-
    keywords(reasoning, KWs), count_matches(Tokens, KWs, C), C >= 2, !.
classify_domain(Tokens, creative) :-
    keywords(creative, KWs), count_matches(Tokens, KWs, C), C >= 2, !.
classify_domain(Tokens, documentation) :-
    keywords(documentation, KWs), count_matches(Tokens, KWs, C), C >= 2, !.
classify_domain(_, unknown). % Fallback

% --- Stakes Policy ---
% Calculate score based on complexity and risk
calculate_stakes_score(Tokens, Score) :-
    findall(V, (member(T, Tokens), complexity_indicator(T, V)), C_Scores),
    findall(V, (member(T, Tokens), risk_indicator(T, V)), R_Scores),
    sum_list(C_Scores, C_Total),
    sum_list(R_Scores, R_Total),
    Score is C_Total + R_Total.

determine_stakes(coding_architecture, _, high) :- !. % Architecture is always high stakes
determine_stakes(_, Score, high) :- Score >= 5, !.
determine_stakes(_, Score, medium) :- Score >= 2, !.
determine_stakes(_, _, low).

% --- Model Selection Policy ---
select_best_model(Domain, Model) :-
    findall(P-M, model_proficiency(M, Domain, P), Pairs),
    keysort(Pairs, Sorted),
    last(Sorted, _-Model).

% --- Validation Policy ---
determine_validation(high, block_by_block).
determine_validation(medium, end_stage).
determine_validation(low, none).

% --- Tool Detection Policy ---
detect_tools(Tokens, ToolsUnique) :-
    findall(Tool, tool_rule(Tokens, Tool), Tools),
    sort(Tools, ToolsUnique).

tool_rule(Tokens, ocr) :- member(scan, Tokens); member(pdf, Tokens).
tool_rule(Tokens, vision) :- member(image, Tokens); member(picture, Tokens).
tool_rule(Tokens, embeddings) :- member(find, Tokens); member(similar, Tokens); member(context, Tokens).

% ------------------------------------------
% 4. MAIN ROUTER ENTRY POINT
% ------------------------------------------

% route(+TokenList, -DecisionDict)
route(Tokens, Decision) :-
    classify_domain(Tokens, Domain),
    calculate_stakes_score(Tokens, Score),
    determine_stakes(Domain, Score, Stakes),
    select_best_model(Domain, Model),
    determine_validation(Stakes, ValPolicy),
    detect_tools(Tokens, Tools),
    
    % Construct Output Dict (SWI-Prolog Dict Syntax)
    Decision = _{
        domain: Domain,
        stakes: Stakes,
        model: Model,
        validation: ValPolicy,
        tools: Tools,
        score: Score
    }.
