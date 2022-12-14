import os
import pickle
from typing import Dict, List, Optional

import marisa_trie


class Table:
    _d: Optional[Dict[str, List[str]]] = None
    _t = None

    def __init__(self):
        if self._d is None:
            self._d, self._t = self._load()
        self.input = ""
        self._buffer = ""
        self.candidates: List[str] = []

    @staticmethod
    def _load():
        root_dir = os.path.join(os.path.dirname(__file__), "..", "..")
        dict_file = os.path.join(root_dir, "table", "table.pickle")
        trie_file = os.path.join(root_dir, "table", "table.marisa")
        d = {}
        with open(dict_file, "rb") as f:
            d = pickle.load(f)
        t = marisa_trie.Trie()
        t.load(trie_file)
        return d, t

    def process_seq(self, seq: str):
        for c in seq:
            self.process(c)

    def process_new_seq(self, seq: str):
        self._reset()
        for c in seq:
            self.process(c)

    def process(self, char: str):
        if self.input != "":
            match char:
                case " ":
                    char = '1'
                case ";":
                    char = '2'
                case "'":
                    char = '3'
        self._push_input(char)

    def pop_input(self) -> str:
        result = self._buffer
        self._buffer = ""
        return result

    def backspace(self):
        self.input = self.input[:-1]
        self._update()

    def enter(self):
        self._buffer += self.input
        self.input = ""
        self._update()

    def _reset(self):
        self.input = ""
        self._buffer = ""
        self.candidates.clear()

    def _extract(self, key: str):
        if self._d is not None and key in self._d:
            return self._d[key]
        else:
            return []

    def _lookup(self, key: str) -> bool:
        try:
            if self._t is not None:
                keys = self._t.iterkeys(key)
                res = next(keys)
                return res is not None
        except:
            return False
        return False

    def _relookup(self, key: str) -> bool:
        try:
            if self._t is not None:
                keys = self._t.iterkeys(key)
                next(keys)
                res = next(keys)
                return res is not None
        except:
            return False
        return False

    def _push_input(self, char: str):
        if self.candidates:
            previous_input = self.input
            self.input += char
            if not self._lookup(self.input):
                self.input = previous_input
                self._update()
                if self.candidates:
                    if not self._select(char):
                        self._buffer += self.candidates[0]
                        self.input = ""
                        self._push_input(char)
                        self._update()
                    else:
                        self.candidates.clear()
                else:
                    self.input = ""
                    self._push_input(char)
                    self._update()
            else:
                self._update()
                if not self._relookup(self.input) and len(self.candidates) == 1:
                    self._buffer += self.candidates[0]
                    self.input = ""
                    self.candidates.clear()
        else:
            self.input += char
            if not self._lookup(self.input):
                self.input = ""
                self._buffer += char
                self.candidates.clear()
            else:
                self._update()
                if not self._relookup(self.input) and len(self.candidates) == 1:
                    self._buffer += self.candidates[0]
                    self.input = ""
                    self.candidates.clear()

    def _update(self):
        self.candidates = self._extract(self.input)[:]

    def _select(self, char: str):
        if len(char) > 1:
            return False
        try:
            index = int(char)
            if len(self.candidates) >= index:
                self._buffer += self.candidates[index - 1]
                self.input = ""
                return True
            else:
                return False
        except:
            return False
