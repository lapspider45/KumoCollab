extends RefCounted

const Lexer = preload('./Lexer.gd')

var _tokens
var current_token;
var _lookadhed_tokens = [];


func set_tokens(tokens):
	_tokens = tokens


func consume(expected = null):
	if !_lookadhed_tokens.size():
		_lookadhed_tokens.push_back(_tokens.next())

	var lookahead = _lookadhed_tokens.pop_front()

	if expected != null and (not lookahead or not expected.has(lookahead.token)):
		_wrong_token_error(lookahead, expected)

	current_token = lookahead;
	return current_token


func peek(expected = null, offset = 0):
	while _lookadhed_tokens.size() < (offset + 1):
		var token = _tokens.next();
		if token:
			_lookadhed_tokens.push_back(token);
		else:
			break

	var lookahead = _lookadhed_tokens[offset] if _lookadhed_tokens.size() > offset else null

	if not expected || (lookahead != null and expected.has(lookahead.token)):
		return lookahead


func _wrong_token_error(token, expected):
	var expected_hints = []
	for e in expected:
		expected_hints.push_back(Lexer.get_token_friendly_hint(e))

	assert(false, "Unexpected token.")
