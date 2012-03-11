// SQF
//
// sqf-library "\css\lib\arrays.sqf"
// Copyright (c) 2009-2010 Denis Usenko (DenVdmj)
// MIT-style license
//

#include "\css\css"


// 
// func(List2Set)
// syntax:
//     (array listOfAnyComparableValues) invoke(List2Set)
// Converts an array-list to array-set. Format of array-set:
//     [
//         ["item 1", count of these items],
//         ["item 2", count of these items],
//         ...
//         ["item N", count of these items]
//     ]
// Example:
//     magazines player invoke(List2Set)
// Result:
//     [
//         ["30Rnd_556x45_Stanag", 6],
//         ["HandGrenade_West", 4]
//     ]
// 

func(List2Set) = {
    private ["_col", "_rem"];
    _col = [];
    for "" from 1 to count _this do {
        if (count _this == 0) exitwith {};
        _rem = _this - [_this select 0];
        _col set [count _col, [_this select 0, count _this - count _rem]];
        _this = _rem;
    };
    _col
};


// 
// func(CanonizeSet)
// syntax:
//     (array listOfAnyComparableValues) invoke(CanonizeSet)
// Function fixes invalid array-set, an example of usage:
//     (
//         (magazines officer1 invoke(List2Set)) +
//         (magazines officer2 invoke(List2Set))
//     ) invoke(CanonizeSet)
// Result:
//     [
//         ["30Rnd_556x45_Stanag", 6],
//         ["7Rnd_45ACP_1911", 8]
//     ]
// 

func(CanonizeSet) = {
    private ["_set", "_keys", "_pos"];
    _set = [];
    _keys = [];
    {
        #define __oldKey    (_x select 0)
        #define __oldValue  (_x select 1)
        #define __newPair   (_set select _pos)
        #define __newKey    (__newPair select 0)
        #define __newValue  (__newPair select 1)
        _pos = _keys find __oldKey;
        if (_pos == -1) then {
            push(_set, _x);
            push(_keys, __oldKey);
        } else {
            __newPair set [1, __newValue + __oldValue]
        };
        #undef __oldKey
        #undef __oldValue
        #undef __newPair
        #undef __newKey
        #undef __newValue
    } foreach _this;
    _set
};


// 
// func(GetUnduplicatedArray)
// syntax:
//     _arrayWithDuplicates invoke(UnduplicatedArray)
// Deletes all duplicate entries in array. Returns new array.
//

func(GetUnduplicatedArray) = {
    private["_e","_i"];
    _i = 0;
    while { count _this != _i } do {
        _e = _this select _i;
        _this = [_e] + ( _this - [_e] );
        _i = _i + 1;
    };
    _this
};

// 
// func(removeItemsFromArray)
// syntax:
//     [_array, _removedEntries] invoke(removeItemsFromArray)
// Deletes all specified entries from specified array. Returns the same modified array.
//

func(removeItemsFromArray) = {
    private ["_array", "_items", "_offset", "_item"];
    _array = arg(0);
    _items = arg(1);
    _offset = 0;
    for "_i" from 0 to count _array do {
        _item = _array select _i;
        if (_offset > 0) then {
            _array set [_i - _offset, _item]
        };
        if (_item in _items) then {
            _offset = _offset + 1;
        };
    };
    _array;
};

// 
// func(MapGrep)
// syntax:
//     [array list, code filter] invoke(MapGrep)
//     [config class, code condition] invoke(MapGrep)
// Returns an array for those elements for which the condition evaluates to notNil. 
// Examples:
// 
//     // Returns all classnames of cars.
//     [configFile >> "CfgVehicles", {
//         if (getText(_x >> "simulation") == "car") then { configName _x }
//     }] invoke(MapGrep)
// 
//     // names of players' soldiers
//     [units player, { name _x }] invoke(MapGrep)
// 
//     // positions of all cars requiring repairs:
//     [allUnits, {
//         if (_x isKindOf "Car" && ! canMove _x) then { getPosASL2 _x }
//     }] invoke(MapGrep)
// 

func(MapGrep) = {
    private ["_SC0PE_", "_x"];
    _SC0PE_ = ["_SC0PE_", "_C0NF_", "_Fi1T3R_", "_1iST_", "_1_"];
    private _SC0PE_;
    _C0NF_ = arg(0);
    _Fi1T3R_ = arg(1);
    _1iST_ = [];
    for "_1_" from 0 to count _C0NF_ -1 do {
        _x = _C0NF_ select _1_;
        // safe own namespace and call user-callback-function
        _Fi1T3R_ call { private _SC0PE_; _x call _this } call {
            push(_1iST_, _this); // push if isn't nil
        };
    };
    _1iST_;
};


// 
// func(SortArray)
// syntax:
//     (two parralel arrays) invoke(SortArray)
// Sort two parralel arrays (using a heapsort algorithm, O(n log n)). Format of arrays:
//     [
//         [values],
//         [linked data]
//     ]
// Example:
//     [
//         [  32,   43,   12,   3,   6565,   43,   3,   4,   5,   234,   876,   872,   7 ],
//         ["_32","_43","_12","_3","_6565","_43","_3","_4","_5","_234","_876","_872","_7"]
//     ] invoke(SortArray)
// Result:
//     [
//         [  3,   3,   4,   5,   7,   12,   32,   43,   43,   234,   872,   876,   6565 ],
//         ["_3","_3","_4","_5","_7","_12","_32","_43","_43","_234","_872","_876","_6565"]
//     ]
// 

func(SortArray)={private["_s","_1","_2","_t","_i","_l","_u","_c","_a","_d"];_s={_a=_1 select
_l;_d=_2 select _l;while{_c=_l+_l+1;if(_c<=_u)then{if(_c<_u)then{if(_1 select _c+1>_1 select
_c)then{_c=_c+1}};if(_1 select _c>_a)then{_1 set[_l,_1 select _c];_2 set[_l,_2 select
_c];_l=_c;true}}}do{};_1 set[_l,_a];_2 set[_l,_d]};_1=_this select 0;_2=_this select
1;_t=count _1-1;_i=floor(_t*.5);while{_i>=0}do{_l=_i;_u=_t;call
_s;_i=_i-1};_i=_t;while{_i>0}do{_a=_1 select 0;_1 set[0,_1 select
_i];_1 set[_i,_a];_d=_2 select 0;_2 set[0,_2 select
_i];_2 set[_i,_d];_l=0;_u=_i-1;call _s;_i=_i-1};_this};


