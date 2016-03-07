#!/bin/bash

haxelib run munit gen
openfl test neko
openfl test cpp
haxelib run munit test
