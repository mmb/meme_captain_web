# Authentication

Authentication when using the API is currently optional. Using an API token
will create all of your images in a user account so they can be managed using
the user interface.

## Generating an API Token

Register a user account, sign in and click the "My Images" link in the header.
Click the "Generate" button to generate an API token.

## Using an API Token

Include this HTTP header in your API requests:

`Authorization: Token token="<put your API token here>"`
