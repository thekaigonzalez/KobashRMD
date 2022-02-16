module kobash.builtins.kobashmain;

// Copyright 2022 kaigonzalez
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import std.stdio;
import std.file;
import std.system;
import std.process;

import core.thread;

import kobash.api.readline;
import kobash.api.user;

string[] parse_string(string c) {
    int state = 1;
    string[] args;
    string point = "";
    for (int i = 0 ; i < c.length ; ++ i) {
        if (c[i] == ' ' && state == 1) {
            args = args ~ point;
            point = "";
            
            state = 2;
        } else if (c[i] == ' ' && state == 2) {
            args = args ~ point;
            point = "";
        } else if (c[i] == '"' && state == 2) {
            state = 122    ;
            
        } else if (c[i] == '"' && state == 122) {
            state = 2;
            args = args ~ point;
            point = "";
        } else {
            point = point ~ c[i];
        }
    }

    if (point.length != 0) {
        args = args ~ point;
    }
    return args;
}

void loadbinary(string[] bin) {
    auto krnl=spawnProcess(bin);

    if (wait(krnl) != 0) {
        
    }

}

void koBashMain() {
    writeln("Welcome to Kobash!");
    if (exists("override")) {
        File c = File("override", "r");
        string override_with = c.readln();
        c.close();

        try {
            loadbinary([override_with]);
        } catch (ProcessException) {
            error("Could not load Terminal override");
        }
    }
}