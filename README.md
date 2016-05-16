# BOE : a Broker On Elixir

**TODO: Add description**

## Usage

### For Beanstalk:
```bash
./boe --beanstalkHost <beanstalkHost> --beanstalkPort <beanstalkPort> --beanstalkTube [ beanstalkTube | #{@default_tube} ]

Options:
--help           Show this help message.
--beanstalkHost  Host to connect to beanstalkd
--beanstalkPort  Port at which beanstalkd is listening
--beanstalkTube  Tube(s) to consume, by default it will be 'default'
                 for all pass 'all', for multiple pass 'tube1, tube2'
```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add boe to your list of dependencies in `mix.exs`:

        def deps do
          [{:boe, "~> 0.0.1"}]
        end

  2. Ensure boe is started before your application:

        def application do
          [applications: [:boe]]
        end
