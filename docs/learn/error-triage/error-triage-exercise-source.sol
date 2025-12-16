// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    /**
     *  Находит разницу между каждым uint и его соседом (a и b, b и c и т.д.)
     * и возвращает массив uint с абсолютной целочисленной разницей для каждой пары.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        results[0] = _a - _b;
        results[1] = _b - _c;
        results[2] = _c - _d;

        return results;
    }

    /**
     * Изменяет _base на значение _modifier. Base всегда >= 1000. Модификаторы могут быть
     * в диапазоне от -100 до +100.
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        return _base + _modifier;
    }

    /**
     * Удаляет последний элемент из предоставленного массива и возвращает удаленное
     * значение (в отличие от встроенной функции)
     */
    uint[] arr;

    function popWithReturn() public returns (uint) {
        uint index = arr.length - 1;
        delete arr[index];
        return arr[index];
    }

    // Вспомогательные функции ниже работают как ожидается
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
