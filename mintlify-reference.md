## Справочник компонентов Mintlify
Полная документация Mintlify доступна по ссылке: https://www.mintlify.com/docs/llms.txt

### docs.json

- Используйте [схему docs.json](https://mintlify.com/docs.json) при создании файла конфигурации и настройке навигации по сайту
- Если какие-либо документы были удалены из папки /docs, убедитесь, что реализовано перенаправление

### Компоненты Callout
Используйте их умеренно - только для выделения информации, которую легко пропустить при беглом просмотре страницы

#### Примечание - Дополнительная полезная информация

<Note>
Дополнительная информация, которая поддерживает основной контент, не прерывая поток
</Note>

#### Совет - Лучшие практики и профессиональные советы

<Tip>
Экспертные рекомендации, сокращения или лучшие практики, которые повышают успех пользователя
</Tip>

#### Предупреждение - Важные предостережения

<Warning>
Важная информация о потенциальных проблемах, несовместимых изменениях и действиях, которые могут привести к потере данных
</Warning>

#### Информация - Нейтральная контекстная информация

<Info>
Фоновая информация, контекст или нейтральные объявления
</Info>

#### Галочка - Подтверждения успеха

<Check>
Положительные подтверждения, успешные завершения или индикаторы достижений
</Check>

### Компоненты кода

#### Code group с несколькими языками

Пример code group:

<CodeGroup>
```javascript Node.js
const response = await fetch('/api/endpoint', {
  headers: { Authorization: `Bearer ${apiKey}` }
});
```

```python Python
import requests
response = requests.get('/api/endpoint', 
  headers={'Authorization': f'Bearer {api_key}'})
```

```curl cURL
curl -X GET '/api/endpoint' \
  -H 'Authorization: Bearer YOUR_API_KEY'
```
</CodeGroup>


### Структурные компоненты

#### Шаги для процедур

Пример пошаговых инструкций:

<Steps>
<Step title="Install dependencies">
  Выполните `npm install` для установки необходимых пакетов.
</Step>

<Step title="Configure environment">
  Создайте файл `.env` с вашими API-учетными данными.
</Step>
</Steps>

#### Вкладки для альтернативного контента

Пример контента с вкладками:

<Tabs>
  <Tab title="macOS">
    ```bash
    brew install node
    npm install -g package-name
    ```
  </Tab>
</Tabs>

#### Accordions для сворачиваемого контента

Пример групп аккордеонов:

<AccordionGroup>
<Accordion title="Troubleshooting connection issues">
  - **Firewall blocking**: Ensure ports 80 and 443 are open
  - **Proxy configuration**: Set HTTP_PROXY environment variable
  - **DNS resolution**: Try using 8.8.8.8 as DNS server
</Accordion>

<Accordion title="Advanced configuration">
  ```javascript
  const config = {
    performance: { cache: true, timeout: 30000 },
    security: { encryption: 'AES-256' }
  };
  ```
</Accordion>
</AccordionGroup>

### Карточки и колонки для акцентирования информации

Пример карточек и групп карточек:

<Card title="Руководство по началу работы" icon="rocket" href="/quickstart">
Пошаговое руководство - от установки до первого вызова API менее чем за 10 минут
</Card>

<CardGroup cols={2}>
<Card title="Аутентификация" icon="key" href="/auth">
  Узнайте, как аутентифицировать запросы с помощью API-ключей или токенов JWT
</Card>

<Card title="Ограничение скорости" icon="clock" href="/rate-limits">
  Поймите, как работают лимиты запросов и как соблюдать лучшие практики при большом объёме трафика
</Card>
</CardGroup>

### Компоненты документации API

#### Поля параметров

Пример описания параметров:

<ParamField path="user_id" type="string" required>
Уникальный идентификатор пользователя. Должен соответствовать формату UUID v4
</ParamField>

<ParamField body="email" type="string" required>
Адрес электронной почты пользователя. Должен быть действительным и уникальным в системе
</ParamField>

<ParamField query="limit" type="integer" default="10">
Максимальное количество возвращаемых результатов. Диапазон: 1–100
</ParamField>

<ParamField header="Authorization" type="string" required>
Токен типа Bearer для аутентификации в API. Формат: `Bearer YOUR_API_KEY`
</ParamField>

#### Поля ответа

Пример описания полей ответа:

<ResponseField name="user_id" type="string" required>
Уникальный идентификатор, присвоенный вновь созданному пользователю
</ResponseField>

<ResponseField name="created_at" type="timestamp">
Отметка времени в формате ISO 8601, когда пользователь был создан
</ResponseField>

<ResponseField name="permissions" type="array">
Список строк разрешений, назначенных данному пользователю
</ResponseField>

#### Разворачиваемые вложенные поля

Пример описания вложенных полей:

<ResponseField name="user" type="object">
Полный объект пользователя со всеми связанными данными

<Expandable title="User properties">
  <ResponseField name="profile" type="object">
  Информация профиля пользователя, включая личные данные
  
  <Expandable title="Profile details">
    <ResponseField name="first_name" type="string">
    Имя пользователя, указанное при регистрации.
    </ResponseField>
    
    <ResponseField name="avatar_url" type="string | null">
    URL изображения профиля пользователя. Возвращает null, если аватар не установлен
    </ResponseField>
  </Expandable>
  </ResponseField>
</Expandable>
</ResponseField>

### Медиа и расширенные компоненты

#### Рамки для изображений

Все изображения следует помещать в рамки:

<Frame>
<img src="/images/dashboard.png" alt="Main dashboard showing analytics overview" />
</Frame>

<Frame caption="The analytics dashboard provides real-time insights">
<img src="/images/analytics.png" alt="Analytics dashboard with charts" />
</Frame>

#### Видео

Используйте HTML-элемент video для видео, размещённого на вашем сервере:

<video
  controls
  className="w-full aspect-video rounded-xl"
  src="link-to-your-video.com"
></video>

Для вставки видео с YouTube используйте элемент iframe:

<iframe
  className="w-full aspect-video rounded-xl"
  src="https://www.youtube.com/embed/4KzFe50RQkQ"
  title="YouTube video player"
  frameBorder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowFullScreen
></iframe>

#### Подсказки

Пример использования всплывающих подсказок:

<Tooltip tip="Application Programming Interface (API) - протоколы для создания программного обеспечения">
API
</Tooltip>

#### Обновления

Используйте компонент обновлений для описания изменений

<Update label="Version 2.1.0" description="Released March 15, 2024">
  
## Новые возможности
- Добавлена функция массового импорта пользователей
- Улучшены сообщения об ошибках - теперь они содержат полезные рекомендации

## Исправления ошибок
- Исправлена проблема с пагинацией при работе с большими наборами данных
- Решена проблема тайм-аута при аутентификации
</Update>

