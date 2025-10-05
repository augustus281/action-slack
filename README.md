# Slack Notify - GitHub Action
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


A [GitHub Action](https://github.com/features/actions) to send a message to a Slack channel.

## Usage

You can use this action after any other action. Here is an example setup of this action:

1. Create a `.github/workflows/slack-notify.yml` file in your GitHub repo.
2. Add the following code to the `slack-notify.yml` file.

```yml
on: push
name: Notify Slack Demo
jobs:
  slackNotification:
    name: Notify Slack
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Notify Slack
      uses: drilonrecica/action-slack-notify@0.0.3
      env:
        SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
```

3. Create `SLACK_WEBHOOK` secret using [GitHub Action's Secret](https://developer.github.com/actions/creating-workflows/storing-secrets). You can [generate a Slack incoming webhook token from here](https://slack.com/apps/A0F7XDUAZ-incoming-webhooks).


## Environment Variables

By default, action is designed to run with minimal configuration but you can alter Slack notification using following environment variables:

Variable       | Default                                               | Purpose
---------------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------
SLACK_CHANNEL  | Set during Slack webhook creation                     | Specify Slack channel in which message needs to be sent
SLACK_USERNAME | `dre's Bot`                                               | The name of the sender of the message. Does not need to be a "real" username
SLACK_ICON     | ![default Avatar](https://github.com/drilonrecica.png?size=32) | User/Bot icon shown with Slack message
SLACK_COLOR    | `good` (green)                                        | You can pass an RGB value like `#efefef` which would change color on left side vertical line of Slack message.
SLACK_MESSAGE  | Generated from git commit message.                    | The main Slack message in attachment. It is advised not to override this.
SLACK_TITLE    | Message                                               | Title to use before main Slack message

You can see the action block with all variables as below:

```yml
    - name: Notify Slack
      uses: drilonrecica/action-slack-notify@0.0.3
      env:
        SLACK_CHANNEL: general
        SLACK_COLOR: '#3278BD'
        SLACK_ICON: https://upload.wikimedia.org/wikipedia/commons/6/68/NoxttonBot.png?size=48
        SLACK_MESSAGE: 'Post Content :rocket:'
        SLACK_TITLE: Post Title
        SLACK_USERNAME: drilonrecica
        SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
```

<!-- Below screenshot help you visualize message part controlled by different variables: -->

<!-- <img width="600" alt="Screenshot_2019-03-26_at_5_56_05_PM" src="https://user-images.githubusercontent.com/4115/54997488-d1f94e00-4ff1-11e9-897f-a35ab90f525f.png"> -->

## Example:
```yml
- uses: augustus281/action-slack@v1
```
