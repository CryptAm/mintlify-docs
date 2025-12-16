---
title: 'Проверка смарт-контракта с помощью API Basescan'
slug: /verify-smart-contract-using-basescan
description: Руководство, которое научит, как проверять смарт-контракт с помощью API Basescan.
author: hughescoin
---

[Basescan] - это обозреватель блоков, специально разработанный для [Base], предоставляющий разработчикам возможность взаимодействовать и проверять смарт-контракты, развернутые на Base. Проверка смарт-контрактов - это критически важный шаг для обеспечения прозрачности и безопасности ончейн-приложений, поскольку она позволяет другим проверять и валидировать исходный код развернутых контрактов. Существует несколько способов проверки контрактов, и к концу этого руководства вы научитесь проверять контракт методом проверки одного файла [Solidity] с использованием [Basescan API].



## Цели обучения

После изучения этого руководства вы сможете:

- Развернуть смарт-контракт с помощью [Foundry]
- Взаимодействовать с [Basescan API] для проверки вашего развернутого контракта
- Получить и настроить (бесплатный) RPC-узел Base от [Coinbase Developer Platform (CDP)](https://portal.cdp.coinbase.com/products/node)



## Предварительные требования

**Знакомство с разработкой смарт-контрактов и языком программирования Solidity**

Solidity - это основной язык программирования для написания смарт-контрактов на Ethereum и совместимых с ним блокчейнах, таких как Base. Вы должны быть знакомы с написанием, компиляцией и развертыванием базовых смарт-контрактов с использованием Solidity. Если нет, ознакомьтесь с [Base Learn].

**Базовое понимание Foundry для разработки на Ethereum**

Foundry - это быстрый и портативный набор инструментов для разработки приложений на Ethereum. Он упрощает процесс развертывания, тестирования и взаимодействия со смарт-контрактами. В этом руководстве предполагается, что у вас есть опыт использования Foundry для компиляции и [deploy smart contracts].

**Доступ к учетной записи Coinbase Developer Platform (CDP)**

[Coinbase Developer Platform] предоставляет доступ к инструментам и услугам, необходимым для блокчейн-разработки, включая RPC-узлы для разных сетей. Вам нужно будет зарегистрировать учетную запись CDP, чтобы получить [Base RPC Node], который будет необходим для развертывания и взаимодействия с вашими смарт-контрактами в блокчейне Base.

**Node + базовые запросы к API**

## Приступаем к делу

Для этого руководства вы развернете простой контракт, который включен в быстрый старт Foundry. Для этого убедитесь, что у вас установлен Foundry.

Если у вас нет Foundry, установите его:

```bash
curl -L https://foundry.paradigm.xyz | bash
```

После установки создайте проект Foundry:

```bash
forge init verify_contracts
```

затем перейдите в только что созданную директорию:

```bash
cd verify_contracts
```

У вас должна быть структура папок, похожая на эту:

```bash
├── lib
├── script
├── src
└── test
```

Папка `src` будет содержать файл `Counter.sol`, который будет служить контрактом, который вы хотите развернуть.

<Note title="Вам понадобится ETH на Base для развертывания">
Вам (кошельку развертывающего) понадобится немного ETH для передачи транзакции в сеть Base. К счастью, транзакции на Base mainnet обычно стоят < 1 цента.

Если вы используете [Coinbase Wallet], используйте кнопку "Купить", чтобы пополнить криптовалютой с вашего счета Coinbase.
</Note>

Вам понадобится приватный ключ кошелька, с которого вы хотите развернуть смарт-контракт. Получите его и сохраните как переменную окружения в вашем терминале.

После того как у вас есть приватный ключ к выбранному вами кошельку, откройте терминал и сохраните его в переменной окружения:

```bash
export PRIVATE_KEY="<YOUR_PRIVATE_KEY>"
```

Для развертывания нашего контракта вам понадобится RPC URL к узлу Base для передачи наших транзакций в сеть. предоставляет нам бесплатный узел для взаимодействия с Base mainnet и testnet.

Получите rpc url из [Node product] и сохраните url как переменную окружения, аналогично приватному ключу на предыдущем шаге.

![cdp-node](/images/verify-with-basescan-api/cdp-node-full.png)

Затем сохраните его как переменную окружения в вашем терминале:

```bash
export BASE_RPC_URL="your_base_rpc_url"
```

Время развертывания! Разверните контракт `Counter.sol`, используя `forge create --rpc-url $BASE_RPC_URL --private-key $PRIVATE_KEY src/Counter.sol:Counter`

После развертывания должно вернуться что-то вроде этого:

```bash ⠊ Compiling...
[⠢] Compiling 1 files with Solc 0.8.26
[⠆] Solc 0.8.26 finished in 1.23s
Compiler run successful!
Deployer: 0xLo69e5523D33FBDbF133E81C91639e9d3C6cb369
Deployed to: 0xEF5fe818Cb814E5c8277C5F12B57106B4EC3DdaA
Transaction hash: 0xb191f9679a1fee253cf430ac09a6838f6806cfb2a250757fef407880f5546836
```

Поздравляем! Теперь вы развернули контракт на Base. Результат команды развертывания содержит адрес контракта (например, `Deployed to: 0xEF5fe818Cb814E5c8277C5F12B57106B4EC3DdaA`). Скопируйте этот адрес, так как он понадобится вам на следующем шаге.

### Проверка контракта

Теперь вы будете взаимодействовать с [Basescan API]. Для этого вам нужны API-ключи. Создайте учетную запись, используя email, или [login to Basescan].

После входа перейдите в [Basescan account] затем выберите `API Keys` на левой панели навигации.

![basescan-sidebar](/images/verify-with-basescan-api/basescan-menu.png)

На [API Key page] нажмите синюю кнопку "Add", чтобы создать новый API-ключ, затем скопируйте ваш `API Key Token`

![basescan-api-key-page](/images/verify-with-basescan-api/basescan-apikey-page-add.png)

Сохраните это в буфере обмена для следующего шага.

Создайте файл `.js`, чтобы создать функцию, которая будет вызывать конечную точку проверки контракта Basescan.

В вашем терминале создайте новый файл: `touch verifyContractBasescan.js`, затем откройте этот файл в предпочитаемой вами IDE.

В верхней части файла создайте переменную, содержащую `Counter.sol`, который был создан из вашего проекта Foundry.

```javascript
const sourceCode = `pragma solidity ^0.8.13;
contract Counter {
	uint256 public number;
	function setNumber(uint256 newNumber) public {
	number = newNumber;
}
	function increment() public {
	number++;
	}
}`;
```

Создайте `async` функцию для вызова API Basescan. Basescan предлагает несколько конечных точек для взаимодействия с их API, базовый URL: `https://api.basescan.org/api`

Для проверки контракта вы будете использовать маршрут `verifysourcecode`, с модулем `contract` и вашим `apiKey` в качестве параметров запроса.

<Tip title="Не уверены, какие данные вводить?">
В каждом проекте Foundry у вас будет файл `.json`, содержащий метаданные контракта и ABI. Для этого конкретного проекта эта информация находится в `/verify_contracts/out/Counter.sol/Counter.json`

В объекте `Metadata` вы найдете версию компилятора в `evmversion`.
</Tip>

Собрав все вместе, наша функция будет выглядеть так:

```
async function verifySourceCode() {
  const url = 'https://api.basescan.org/api';

  const params = new URLSearchParams({
    module: 'contract',
    action: 'verifysourcecode',
    apikey: 'DK8M329VYXDSKTF633ABTK3SAEZ2U9P8FK', //remove hardcode
  });

  const data = new URLSearchParams({
    chainId: '8453',
    codeformat: 'solidity-single-file',
    sourceCode: sourceCode,
    contractaddress: '0x8aB096ea9886ACe363f81068d2439033F67F62E4',
    contractname: 'Counter',
    compilerversion: 'v0.8.26+commit.8a97fa7a',
    optimizationUsed: 0,
    evmversion: 'paris',
  });
  }
```

Теперь добавьте блок `try-catch`, чтобы отправить запрос и залогировать любые ошибки в консоль.

Ваш итоговый файл должен выглядеть примерно так:

```javascript
const sourceCode = `pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}`;

async function verifySourceCode() {
  const url = 'https://api.basescan.org/api';

  const params = new URLSearchParams({
    module: 'contract',
    action: 'verifysourcecode',
    apikey: 'YOUR_API_KEY',
  });

  const data = new URLSearchParams({
    chainId: '8453',
    codeformat: 'solidity-single-file',
    sourceCode: sourceCode,
    contractaddress: '0x8aB096ea9886ACe363f81068d2439033F67F62E4',
    contractname: 'Counter',
    compilerversion: 'v0.8.26+commit.8a97fa7a',
    optimizationUsed: 0,
    evmversion: 'paris',
  });

  try {
    const response = await fetch(`${url}?${params}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: data,
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result = await response.json();
    console.log(result);
    return result;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

verifySourceCode().catch((error) => console.error('Unhandled error:', error));
```

Сохраните ваш файл, а затем запустите `node verifyContractBasescan.js` в вашем терминале.

В случае успеха ваш терминал выведет JSON-текст с тремя свойствами: `status`, `message` и `result`, как показано ниже:

```bash
{
  status: '1',
  message: 'OK',
  result: 'cqjzzvppgswqw5adq4v6iq4xkmf519pj1higvcxsdiwcvwxemd'
}
```

Result - это GUID и уникальный идентификатор для проверки статуса проверки вашего контракта.

Чтобы проверить контракт, создайте curl-запрос со следующими параметрами:

```bash
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=cqjzzvppgswqw5adq4v6iq4xkmf519pj1higvcxsdiwcvwxemd&apikey=DK8M329VYXDSKTF633ABTK3SAEZ2U9P8FK"
```

Запустите команду, и вы увидите, что контракт уже должен быть проверен на основе поля `result`:

```json
{ "status": "0", "message": "NOTOK", "result": "Already Verified" }
```

## Заключение

Поздравляем! Вы успешно развернули и проверили смарт-контракт с помощью API Basescan. Теперь вашим пользователям не нужно полагаться только на ваше слово - они могут проверить функциональность контракта через сам код.



[Coinbase Developer Platform]: https://portal.cdp.coinbase.com/
[Base RPC Node]: https://portal.cdp.coinbase.com/products/node
[CDP]: https://portal.cdp.coinbase.com/
[Base]: https://base.org/
[Basescan]: https://basescan.org/
[Solidity]: https://soliditylang.org/
[Basescan account]: https://basescan.org/myaccount/
[API Key page]: https://basescan.org/myapikey/
[Basescan API]: https://docs.basescan.org/
[login to Basescan]: https://basescan.org/login/
[Node product]: https://portal.cdp.coinbase.com/products/node/
[deploy smart contracts]: https://docs.base.org/tutorials/deploy-with-foundry/
[Base Learn]: https://docs.base.org/learn/welcome/
[Foundry]: https://book.getfoundry.sh/getting-started/installation
