---
title: Создание контрактов со случайными числами с помощью Supra dVRF
slug: /oracles-supra-vrf
description: Руководство, которое научит использовать Supra dVRF для предоставления случайных чисел с помощью механизма генерации случайности непосредственно в ваших смарт-контрактах в тестовой сети Base.
author: taycaldwell
keywords: [
    Oracle
    Oracles,
    Supra,
    Supra VRF,
    Supra dVRF,
    VRF,
    verifiable random function,
    verifiable random functions,
    random numbers,
    rng,
    random number generator,
    random numbers in smart contracts,
    random numbers on Base,
    smart contract,
    Base blockchain,
    Base network,
    Base testnet,
    Base test network,
    app development,
    dapp development,
    build a dapp on Base,
    build on Base,
  ]
tags: ['oracles', 'vrf']
difficulty: intermediate
displayed_sidebar: null
---

Это руководство проведет вас через процесс создания смарт-контракта на Base, который использует Supra dVRF для предоставления случайных чисел с помощью механизма генерации случайности непосредственно в ваших смарт-контрактах.



## Цели обучения

После изучения этого руководства вы сможете сделать следующее:

- Настроить проект смарт-контракта для Base с помощью Foundry
- Установить Supra dVRF как зависимость
- Использовать Supra dVRF в вашем смарт-контракте
- Развернуть и протестировать ваши смарт-контракты на Base



## Предварительные требования

### Foundry

Это руководство требует установленного Foundry.

- Из командной строки (терминала) выполните: `curl -L https://foundry.paradigm.xyz | bash`
- Затем выполните `foundryup`, чтобы установить последнюю (ночную) сборку Foundry

Для получения дополнительной информации смотрите [руководство по установке](https://book.getfoundry.sh/getting-started/installation) в книге Foundry.

### Coinbase Wallet (кошелек)

Чтобы развернуть смарт-контракт, вам сначала понадобится кошелек. Вы можете создать кошелек, загрузив расширение для браузера Coinbase Wallet.

- Скачайте [Coinbase Wallet](https://chrome.google.com/webstore/detail/coinbase-wallet-extension/hnfanknocfeofbddgcijnmhnfnkdnaad?hl=en)

### Средства в кошельке

Развертывание контрактов в блокчейне требует оплаты комиссии за газ. Поэтому вам нужно будет пополнить свой кошелек ETH для покрытия этих комиссий.

Для этого руководства вы будете развертывать контракт в тестовой сети Base Sepolia. Вы можете пополнить свой кошелек Base Sepolia ETH, используя один из кранов, перечисленных на странице [Network Faucets](https://docs.base.org/chain/network-faucets) Base.

### Регистрация кошелька в Supra

<Caution>
Supra dVRF V2 требует подписки на сервис с адресом кошелька, контролируемым клиентом, который будет выступать в качестве основного справочного элемента.

Поэтому вы должны зарегистрировать свой кошелек в команде Supra, если планируете использовать Supra dVRF V2 в своих смарт-контрактах.

Пожалуйста, обратитесь к [документации Supra](https://docs.supra.com/oracles/dvrf/vrf-subscription-model) для получения актуальных шагов по регистрации вашего кошелька для их сервиса.
</Caution>



## Что такое Верифицируемая Случайная Функция (VRF)?

Верифицируемая Случайная Функция (VRF) предоставляет решение для генерации случайных результатов децентрализованным и проверяемо записываемым в блокчейн способом. VRF критически важны для приложений, где целостность случайности имеет первостепенное значение, например, в играх или розыгрышах призов.

Supra dVRF предоставляет децентрализованную VRF, которая гарантирует, что результаты не только эффективно случайны, но и отзывчивы, масштабируемы и легко проверяемы, удовлетворяя уникальные потребности ончейн-приложений в надежной и прозрачной случайности.



## Создание проекта

Прежде чем начать писать смарт-контракты для Base, вам нужно настроить среду разработки, создав проект Foundry.

Чтобы создать новый проект Foundry, сначала создайте новую директорию:

```bash
mkdir myproject
```

Затем выполните:

```bash
cd myproject
forge init
```

Это создаст проект Foundry со следующей базовой структурой:

```bash
.
├── foundry.toml
├── script
 │   └── Counter.s.sol
├── src
 │   └── Counter.sol
└── test
    └── Counter.t.sol
```



## Написание смарт-контракта

После создания вашего проекта Foundry вы можете начать писать смарт-контракт.

Приведенный ниже код Solidity определяет базовый контракт с именем `RNGContract`. Конструктор смарт-контракта принимает один `address` и присваивает его переменной-члену с именем `supraAddr`. Этот адрес соответствует [адресу контракта](https://docs.supra.com/oracles/data-feeds/pull-oracle/networks) контракта Supra Router Contract, который будет использоваться для генерации случайных чисел. Адрес контракта Supra Router Contract в тестовой сети Base Sepolia - `0x99a021029EBC90020B193e111Ae2726264a111A2`.

Контракт также присваивает развертывающего контракт (`msg.sender`) переменной-члену с именем `supraClientAddress`. Это должен быть адрес клиентского кошелька, который зарегистрирован и внесен в белый список для использования Supra VRF (см.: [Предварительные требования](#prerequisites)).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RNGContract {
    address supraAddr;
    address supraClientAddress;

    constructor(address supraSC) {
        supraAddr = supraSC;
        supraClientAddress = msg.sender;
    }
}
```

В вашем проекте добавьте предоставленный выше код в новый файл с именем `src/ExampleContract.sol`, и удалите контракт `src/Counter.sol` который был сгенерирован с проектом. (Вы также можете удалить файлы `test/Counter.t.sol` и `script/Counter.s.sol` files).

Следующие разделы проведут вас шаг за шагом по обновлению вашего контракта для генерации случайных чисел с помощью контракта Supra Router.

### Добавление интерфейса контракта Supra Router

Чтобы помочь вашему контракту (контракту-запрашивателю) взаимодействовать с контрактом Supra Router и понимать, какие методы он может вызывать, вам нужно добавить следующий интерфейс в файл вашего контракта.

```solidity
interface ISupraRouter {
	function generateRequest(string memory _functionSig, uint8 _rngCount, uint256 _numConfirmations, uint256 _clientSeed, address _clientWalletAddress) external returns(uint256);
	function generateRequest(string memory _functionSig, uint8 _rngCount, uint256 _numConfirmations, address _clientWalletAddress) external returns(uint256);
}
```

Интерфейс `ISupraRouter` определяет функцию `generateRequest`. Эта функция используется для создания запроса на случайные числа. Функция `generateRequest` определена дважды, потому что одно из определений позволяет использовать дополнительный `_clientSeed` (по умолчанию `0`) для дополнительной непредсказуемости.

<Info>
В качестве альтернативы вы можете добавить интерфейс `ISupraRouter` в отдельный файл интерфейса и наследовать интерфейс в вашем контракте.
</Info>

### Добавление функции запроса

После определения `ISupraRouter` вы готовы добавить логику в ваш смарт-контракт для запроса случайных чисел.

Для Supra dVRF добавление логики для запроса случайных чисел требует двух функций:

- Функция запроса
- Функция обратного вызова (callback)

Функция запроса - это пользовательская функция, определяемая разработчиком. Нет требований к сигнатуре функции запроса.

Следующий код - пример функции запроса с именем `rng`, которая запрашивает случайные числа с помощью контракта Supra Router Contract. Добавьте эту функцию в ваш смарт-контракт:

```solidity
function rng() external returns (uint256) {
    // Количество случайных чисел для запроса
    uint8 rngCount = 5;
    // Количество подтверждений, прежде чем запрос будет считаться завершенным/окончательным
    uint256 numConfirmations = 1;
    uint256 nonce = ISupraRouter(supraAddr).generateRequest(
        "requestCallback(uint256,uint256[])",
        rngCount,
        numConfirmations,
        supraClientAddress
    );
    return nonce;
    // при необходимости сохраните nonce (например, в хэш-карте)
    // это можно использовать для отслеживания параметров, связанных с запросом, в таблице поиска
    // к ним можно получить доступ внутри обратного вызова, поскольку ответ от supra будет включать nonce
}
```

Функция `rng` выше запрашивает `5` случайных чисел (определено `rngCount`) и ждет `1` подтверждение (определено `numConfirmations`), прежде чем считать результат окончательным. Она делает этот запрос, вызывая функцию `generateRequest` контракта Supra Router, предоставляя функцию обратного вызова с сигнатурой `requestCallback(uint256,uint256[])`.

### Добавление функции обратного вызова

Как видно в предыдущем разделе, метод `generateRequest` контракта Supra Router ожидает сигнатуру для функции обратного вызова. Эта функция обратного вызова должна быть вида: `uint256 nonce, uint256[] calldata rngList` и должна включать код валидации, чтобы только контракт Supra Router мог вызывать эту функцию.

Для этого добавьте следующую функцию обратного вызова (`requestCallback`) в ваш смарт-контракт:

```solidity
function requestCallback(uint256 _nonce ,uint256[] _rngList) external {
    require(msg.sender == supraAddr, "Only the Supra Router can call this function.");
    uint8 i = 0;
    uint256[] memory x = new uint256[](rngList.length);
    rngForNonce[nonce] = x;
    for(i=0; i<rngList.length;i++){
        rngForNonce[nonce][i] = rngList[i] % 100;
    }
}
```

После генерации случайного числа `requestCallback` выполняется Supra Router. Приведенный выше код сохраняет результирующий список случайных чисел в карте с именем `rngForNonce`, используя аргумент `_nonce`. Из-за этого вам нужно будет добавить следующее отображение (mapping) в ваш контракт:

```solidity
mapping (uint256 => uint256[] ) rngForNonce;
```

### Добавление функции для просмотра результата

Чтобы получить результирующие случайные числа на основе связанного с ними `nonce`, добавьте третью функцию:

```solidity
function viewRngForNonce(uint256 nonce) external view returns (uint256[] memory) {
    return rngForNonce[nonce];
}
```

### Итоговый код смарт-контракта

После выполнения всех шагов выше код вашего смарт-контракта должен выглядеть следующим образом:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISupraRouter {
    function generateRequest(string memory _functionSig, uint8 _rngCount, uint256 _numConfirmations, uint256 _clientSeed, address _clientWalletAddress) external returns (uint256);
    function generateRequest(string memory _functionSig, uint8 _rngCount, uint256 _numConfirmations, address _clientWalletAddress) external returns (uint256);
}

contract RNGContract {
    address supraAddr;
    address supraClientAddress;

    mapping (uint256 => uint256[]) rngForNonce;

    constructor(address supraSC) {
        supraAddr = supraSC;
        supraClientAddress = msg.sender;
    }

    function rng() external returns (uint256) {
        // Количество случайных чисел для запроса
        uint8 rngCount = 5;
        // Количество подтверждений, прежде чем запрос будет считаться завершенным/окончательным
        uint256 numConfirmations = 1;
        uint256 nonce = ISupraRouter(supraAddr).generateRequest(
            "requestCallback(uint256,uint256[])",
            rngCount,
            numConfirmations,
            supraClientAddress
        );
        return nonce;
    }

    function requestCallback(uint256 _nonce, uint256[] memory _rngList) external {
        require(msg.sender == supraAddr, "Only the Supra Router can call this function.");
        uint8 i = 0;
        uint256[] memory x = new uint256[](_rngList.length);
        rngForNonce[_nonce] = x;
        for (i = 0; i < _rngList.length; i++) {
            rngForNonce[_nonce][i] = _rngList[i] % 100;
        }
    }

    function viewRngForNonce(uint256 nonce) external view returns (uint256[] memory) {
        return rngForNonce[nonce];
    }
}
```

<Warning>
Вы должны внести этот смарт-контракт в белый список под адресом кошелька, который вы зарегистрировали в Supra, и внести средства для оплаты комиссий за газ, связанных с транзакциями для вашей функции обратного вызова.

Следуйте [шагам руководства](https://supraoracles.com/docs/vrf/v2-guide#step-1-create-the-supra-router-contract-interface-1), предоставленным Supra, для внесения вашего контракта в белый список и внесения средств.

Если вы еще не зарегистрировали свой кошелек в Supra, см. раздел [Предварительные требования](#prerequisites).
</Warning>



## Компиляция смарт-контракта

Чтобы скомпилировать код вашего смарт-контракта, выполните:

```bash
forge build
```



## Развертывание смарт-контракта

### Настройка вашего кошелька как развертывающего

Прежде чем вы сможете развернуть ваш смарт-контракт в сети Base, вам нужно настроить кошелек, который будет использоваться как развертывающий.

Для этого вы можете использовать команду [`cast wallet import`](https://book.getfoundry.sh/reference/cast/cast-wallet-import), чтобы импортировать приватный ключ кошелька в безопасное зашифрованное хранилище ключей Foundry:

```bash
cast wallet import deployer --interactive
```

После выполнения команды выше вам будет предложено ввести ваш приватный ключ, а также пароль для подписания транзакций.

<Warning>
Инструкции о том, как получить ваш приватный ключ из Coinbase Wallet, смотрите в [документации Coinbase Wallet](https://docs.cloud.coinbase.com/wallet-sdk/docs/developer-settings#show-private-key).

**Крайне важно НЕ коммитить это в публичный репозиторий.**.
</Warning>

Чтобы подтвердить, что кошелек был импортирован как учетная запись `deployer` в вашем проекте Foundry, выполните:

```bash
cast wallet list
```

### Настройка переменных окружения для Base Sepolia

Чтобы настроить ваше окружение для развертывания в сети Base, создайте файл `.env` в домашней директории вашего проекта и добавьте RPC URL для тестовой сети Base Sepolia, а также адрес контракта Supra Router для тестовой сети Base Sepolia:

```
BASE_SEPOLIA_RPC="https://sepolia.base.org"
ISUPRA_ROUTER_ADDRESS=0x99a021029EBC90020B193e111Ae2726264a111A2
```

После создания файла `.env` выполните следующую команду, чтобы загрузить переменные окружения в текущей сессии командной строки:

```bash
source .env
```

### Развертывание смарт-контракта в Base Sepolia

Теперь, когда ваш контракт скомпилирован и окружение настроено, вы готовы развернуть смарт-контракт в тестовой сети Base Sepolia!

Для развертывания одного смарт-контракта с помощью Foundry вы можете использовать команду `forge create`. Команда требует указать смарт-контракт, который вы хотите развернуть, RPC URL сети, в которую вы хотите развернуть, и учетную запись, с которой вы хотите развернуть.

Чтобы развернуть смарт-контракт `RNGContract` в тестовой сети Base Sepolia, выполните следующую команду:

```bash
forge create ./src/RNGContract.sol:RNGContract --rpc-url $BASE_SEPOLIA_RPC --constructor-args $ISUPRA_ROUTER_ADDRESS --account deployer
```

Когда будет предложено, введите пароль, который вы установили ранее, при импорте приватного ключа вашего кошелька.

<Info>
Ваш кошелек должен быть пополнен ETH в тестовой сети Base Sepolia для покрытия комиссий за газ, связанных с развертыванием смарт-контракта. В противном случае развертывание завершится неудачей.

Чтобы получить тестовый ETH для Base Sepolia, смотрите [предварительные требования](#prerequisites).
</Info>

После выполнения команды выше контракт будет развернут в тестовой сети Base Sepolia. Вы можете просмотреть статус развертывания и контракт, используя [обозреватель блоков](/chain/block-explorers).



## Взаимодействие со смарт-контрактом

Foundry предоставляет инструмент командной строки `cast`, который можно использовать для взаимодействия с развернутым смарт-контрактом и вызова функции `getLatestPrice()` для получения последней цены ETH.

Чтобы вызвать функцию `getLatestPrice()` смарт-контракта, выполните:

```bash
cast call <DEPLOYED_ADDRESS> --rpc-url $BASE_SEPOLIA_RPC "rng()"
```

Вы должны получить значение `nonce`.

Вы можете использовать это значение `nonce` для вызова функции `viewRngForNonce(uint256)`, чтобы получить результирующий список сгенерированных случайных чисел:

```bash
cast call <DEPLOYED_ADDRESS> --rpc-url $BASE_SEPOLIA_RPC "viewRngForNonce(uint256)" <NONCE>
```



## Заключение

Поздравляем! Вы успешно развернули и взаимодействовали со смарт-контрактом, который генерирует список случайных чисел с помощью Supra dVRF в блокчейн-сети Base.

Чтобы узнать больше о VRF и использовании Supra dVRF для генерации случайных чисел в ваших смарт-контрактах на Base, ознакомьтесь со следующими ресурсами:

- [Oracles](https://docs.base.org/tools/oracles)
- [Supra dVRF - Developer Guide V2](https://supraoracles.com/docs/vrf/v2-guide)
