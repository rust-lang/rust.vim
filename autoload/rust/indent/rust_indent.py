from __future__ import print_function

# This Python code should be compatible to both Python 2 and Python 3

import re
import sys
import copy

if (sys.version_info >= (3, 0)):
    from colors import color
else:
    def color(s, **args):
        return s
import sys

TOKEN = '|'.join([ '[ \t]+', '[a-zA-Z][a-zA-Z0-9_]*', '//', '::', "\\\"",
   '[>][=]', '[<][=]', '[=][>]', '[-][>]', '/[*]', '[*]/', '\n', '.'])
TOKEN = re.compile(TOKEN)

def indent(line_str, shiftwidth):
    """
    Return the amount of prefixed spaces.
    """
    m = re.match(r"^([ \t]*)", line_str)

    level = 0
    for i in m.groups()[0]:
        if i == ' ':
            level = level + 1
        elif i == '\t':
            level = (1 + int(level/shiftwidth))*shiftwidth

    return level

NO_PRINTS = 0

def print_log(*args):
    if NO_PRINTS:
        return
    print(*args)

class ItemState(object):
    """
    The Item state tracks the 'token trees'. A token tree is anything that is
    enclosed in all kinds of braces, possibly prefixed by other tokens. Usually
    a single expression is an item. A list of expression delimited by ',' or ';'
    makes a list item. For example 'if condition {a; b; }' is one item containing
    two items.
    """
    def __init__(self, pos):
        self.pos = pos
        self.item_known = None
        self.next_token_start_inner = True
        self.indent = 0
        self.where = False
        self.has_more_tokens_in_line = False

    def __repr__(self):
        return "Item(%r)" % vars(self)

class LineState(object):
    """
    The LineState represents the state of the token parser, including notion
    of in which 'token tree' we are, and our current item stack.
    """
    def __init__(self, start_state=None):
        if start_state is None:
            self.in_comment = None
            self.in_string = 0
            self.nesting = 0
            self.item_stack = []
            self.current_item = ItemState([1, 1])
        else:
            self.nesting = start_state.nesting
            self.in_comment = start_state.in_comment
            self.in_string = start_state.in_string
            self.item_stack = copy.deepcopy(start_state.item_stack)
            self.current_item = copy.deepcopy(start_state.current_item)

def parse_line(state, line_num, line_tokens, line_archive, shiftwidth):
    """

    This is the main function for the algorithm.

    @state: The LineState
    @line_num: The line number to indent
    @line_tokens: The tokens of the line
    @line_archive: A dictionary or list of the previous lines, keyed by the line numbers
    @shiftwidth: The indentation shift width (usually 4).

    We do not try to do exact parsing of the input token stream. Instead, we mainly
    try to track {}, [], (), and figure out their related tokens that make up an
    Item tree.
    """

    state = LineState(state)
    prev_ws_token = False
    current_item = state.current_item
    item_stack = state.item_stack
    errors = 0
    token_col = 0

    line = ''
    nr_tokens = len(line_tokens)
    idx = 0
    guess = None

    for token in ["\n"] + line_tokens:
        if state.in_comment == "//" and token == "\n":
            state.in_comment = None
        string_start = 0

        if state.in_comment is None:
            if token == "/*" or token == "//":
                state.in_comment = token
        if state.in_comment is None and state.in_string == 0 and token == "\"":
            state.in_string = 1
            string_start = 1

        ws_token = token.strip() == ''

        if token != "\n":
            token_col = len(line) + 1

            line_stripped_before_token = line.strip()
            line += token
            line_stripped = line.strip()
            first_non_ws_token = line_stripped_before_token == '' and line_stripped != ''
        else:
            first_non_ws_token = None

        if ((token == "\n") or first_non_ws_token) and state.in_comment is None and not state.in_string:
            print_log(color("    current item: %r" % (current_item, ), fg='green'))
            indent_level = indent(line, shiftwidth)
            item_line = None
            diff = 0
            guess = 0

            lookup_item = current_item
            if token in '}])' or (token in "{" and lookup_item.where):
                if len(item_stack) > 0:
                    lookup_item = item_stack[-1]

            if lookup_item.item_known != None and not lookup_item.next_token_start_inner:
                item_line = lookup_item.item_known[0]
                guess = None
                if item_line != line_num:
                    if token not in '}]){[(':
                        if lookup_item.item_known[2] != "#":
                            if token != "where":
                                diff = shiftwidth
                            else:
                                if idx < len(line_tokens):
                                    diff = shiftwidth
            elif len(item_stack) > 0:
                if current_item.has_more_tokens_in_line:
                    guess = current_item.pos[1]
                else:
                    item_line = current_item.pos[0]
                    if token not in '}])':
                        diff = shiftwidth
                    guess = None

            if guess is None:
                if item_line != 0:
                    guess = indent(line_archive[item_line], shiftwidth) + diff
                elif state.in_string or state.in_comment:
                    guess = indent(line, shiftwidth)
                else:
                    guess = 0

            if idx != 0:
                if guess != indent_level:
                    print_log(color("    err: mismatch guess=%r, indent_level=%d, item_line=%r, diff=%d"
                        % (guess, indent_level, item_line, diff), fg='red'))
                    errors += 1
                else:
                    print_log(color("    OK (indent=%d)" % (guess, ), fg="blue"))
            else:
                print_log(color("    OK (guess=%d)" % (guess, ), fg="blue"))


        if state.in_comment is None and not (state.in_string and not string_start) and token.strip() != '':
            if token in '[{(' or (token == '<' and not prev_ws_token) or token == "where":
                if current_item.where and token == "{":
                    current_item = item_stack.pop()
                    current_item.next_token_start_inner = True
                    print_log(color("    <- where { pop %s" % (current_item, ), fg='green'))
                    state.nesting -= 1

                if token in '[(':
                    current_item.next_token_start_inner = False

                state.nesting += 1
                print_log(color("    -> push %r" % (current_item, ), fg='green'))
                item_stack.append(current_item)
                current_item = ItemState([line_num, token_col])
                current_item.has_more_tokens_in_line = idx < len(line_tokens)
                if token == "where":
                    current_item.where = True
            elif token in '}])' or (token == '>' and not prev_ws_token):
                if state.nesting >= 1:
                    current_item = item_stack.pop()
                    if token in '}':
                        current_item.next_token_start_inner = True
                    print_log(color("    <- pop %s" % (current_item, ), fg='green'))
                    state.nesting -= 1
                else:
                    print_log(color("    err: unbalanced", fg='red'))
                    errors += 1
            elif token in ';,':
                if current_item.where and token == ";":
                    current_item = item_stack.pop()
                    current_item.next_token_start_inner = True
                    print_log(color("    <- where ; pop %s" % (current_item, ), fg='green'))
                    state.nesting -= 1

                print_log(color("     %s delimit" % (token, ), fg='white'))
                current_item.next_token_start_inner = True
            else:
                if not token.startswith("//"):
                    if current_item.next_token_start_inner:
                        current_item.item_known = [line_num, token_col, token]
                        print_log(color("     %s - item known" % (token, ), fg='cyan'))
                        current_item.next_token_start_inner = False

        if state.in_comment == "/*" and token == "*/":
            state.in_comment = None
        if not state.in_comment and not string_start and state.in_string and token == "\"":
            state.in_string = 0

        prev_ws_token = ws_token
        idx += 1

    state.current_item = current_item

    print_log(color("    Line ended. state.in_comment=%r, nesting=%d, item_stack=%r"
        % (state.in_comment, state.nesting, item_stack), fg='blue'))
    print_log(color("%d: %s" % (line_num, line), fg='white'))
    print_log("")

    return (state, errors, guess)

CACHE_KEY = None
CACHE = [None]
ARCHIVE = [None]

def get_line_indent(line_array, start_line, lnum, buf_nr, shiftwidth):
    """
    Indentation entry point from within Vim.

    This function is called from
    """
    global NO_PRINTS
    NO_PRINTS = 1

    global CACHE
    global CACHE_KEY
    global ARCHIVE

    assert lnum >= start_line

    if CACHE_KEY != (buf_nr, start_line):
        CACHE_KEY = (buf_nr, start_line)
        CACHE = [None]
        ARCHIVE = [None]

    lnum -= start_line - 1
    i = 1
    while i <= lnum and i < len(CACHE):
        if ARCHIVE[i] != line_array[start_line - 1 + i - 1]:
            break
        i += 1

    if i >= 2:
        i -= 1
    del CACHE[i:]
    del ARCHIVE[i:]

    if len(CACHE) == 1:
        line_state = LineState()
    else:
        line_state = CACHE[-1]

    errors = 0
    guess = 0

    while i <= lnum:
        line = line_array[start_line - 1 + i - 1]
        tokens = TOKEN.findall(line)
        (next_line_state, line_errors, guess) = parse_line(line_state, i, tokens, ARCHIVE, shiftwidth)
        errors += line_errors
        CACHE.append(next_line_state)
        ARCHIVE.append(line)
        line_state = next_line_state
        i += 1

    if not guess:
        guess = 0

    return guess

def calculate_whole_buffer_indent(content, shiftwidth):
    """
    This function indents a whole file.

    Used only for command line testing.
    """
    line_archive = {}
    line = ""

    result = {}
    line_num = 1
    errors = 0
    line_state = LineState()
    all_tokens = list(TOKEN.findall(content))

    line = []
    for (token_idx, token) in enumerate(all_tokens):
        if token != "\n":
            line.append(token)
        else:
            line_archive[line_num] = ''.join(line)
            (line_state, line_errors, _) = parse_line(line_state, line_num, line, line_archive, shiftwidth)
            errors += line_errors
            line = []
            line_num += 1

    if errors > 0:
        print_log(color("errors: %d" % (errors, ), fg='red'))

    return result

def main():
    """

    This function is used for command line testing of the indentation algorithm.

    Modes of operation:

    Whole file:

      python rust-indent.py [filename]

    Particular lines:

      python rust-indent.py [filename] [line_nr1] [line_nr_2]


    """
    args = sys.argv[1:]
    indent = 4

    for i, arg in enumerate(args):
        if arg.startswith('--indent='):
            indent = int(arg[len("--indent="):])
            del args[i]
            break

    content = open(args[0]).read()
    if len(args) >= 2:
        lines = content.splitlines()
        for param in args[1:]:
            lnum = int(param)
            print(get_line_indent(lines, 1, lnum, 0, indent))
    else:
        calculate_whole_buffer_indent(content, indent)

if __name__ == "__main__":
    main()
