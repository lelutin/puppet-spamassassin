require 'spec_helper'

describe 'spamassassin' do
  let(:facts) { { is_virtual: 'false' } }

  context 'with a non-supported os family' do
    let(:params) { {} }
    let :facts do
      {
        os: {
          family: 'foo',
          name: 'bar',
        },
      }
    end

    it 'fails' do
      is_expected.to raise_error(Puppet::Error, %r{bar is not supported by this module.})
    end
  end

  %w[Debian RedHat].each do |system|
    context "when on system #{system}" do
      let :facts do
        super().merge(
          {
            os: {
              family: system,
              release: {
                # some checks test that we use the differing default options
                # for each distro. this version number triggers redhat default
                # versions
                major: '8',
              },
            },
          }
        )
      end

      it { is_expected.to create_class('spamassassin') }
      it { is_expected.to contain_class('spamassassin::params') }

      it {
        is_expected.to contain_package('spamassassin').with(
          ensure: 'installed',
        )
      }

      it {
        is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
          ensure: 'file',
        )
      }

      it {
        is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
          ensure: 'file',
        )
      }

      it {
        is_expected.to contain_file('/etc/mail/spamassassin/v312.pre').with(
          ensure: 'file',
        )
      }

      it {
        is_expected.to contain_file('/etc/mail/spamassassin/v320.pre').with(
          ensure: 'file',
        )
      }

      describe 'with default service' do
        let(:params) { { service_enabled: false } }

        it {
          is_expected.to contain_service('spamassassin').with(
            ensure: false,
            enable: false,
            pattern: 'spamd',
            require: 'Package[spamassassin]',
          )
        }
      end

      describe 'with spamd enabled' do
        let(:params) { { service_enabled: true } }

        if system == 'RedHat'
          it {
            is_expected.to contain_file_line('spamd_options').with(
              {
                'line' => %r{SPAMDOPTIONS="-d -c -H -m 5 -i localhost -A 127.0.0.1/32 -A \[::1\]/8"},
              },
            )
          }
        else
          it {
            is_expected.to contain_file_line('spamd_service').with(
              {
                'line' => %r{ENABLED=1},
              },
            )
          }

          it {
            is_expected.to contain_file_line('spamd_options').with(
              {
                'line' => %r{OPTIONS="-c -H -m 5 -i localhost -A 127.0.0.1/32 -A \[::1\]/8"},
              },
            )
          }
        end

        it {
          is_expected.to contain_service('spamassassin').with(
            ensure: true,
            enable: true,
            pattern: 'spamd',
            require: 'Package[spamassassin]',
          )
        }
      end

      describe 'with all extra service options enabled' do
        let(:params) do
          {
            service_enabled: true,
            spamd_username: 'myuser',
            spamd_groupname: 'mygroup',
            spamd_max_children: 42,
            spamd_min_children: 2,
            spamd_listen_address: ['127.0.0.2'],
            spamd_allowed_ips: ['10.0.0.0/8'],
            spamd_nouserconfig: true,
            spamd_allowtell: true,
            spamd_sql_config: true,
            user_scores_dsn: 'DBI:mysql:spamassassin:localhost:3306',
            user_scores_sql_username: 'sqluser',
            user_scores_sql_password: 'somesecret',
            spamd_syslog_facility: '/var/log/spamd.log',
          }
        end

        opts = '-u myuser -s /var/log/spamd.log -g mygroup -m 42 --min-children=2 -i 127.0.0.2 '\
               '-A 10.0.0.0/8 --nouser-config --allow-tell -q'
        it {
          is_expected.to contain_file_line('spamd_options').with(
            {
              'line' => %r{(?:SPAMD)?OPTIONS=".+\s#{opts}"},
            },
          )
        }
      end

      describe 'with auto update enabled' do
        let(:params) { { sa_update: true } }

        if system == 'RedHat'
          it {
            is_expected.to contain_file_line('sa_update').with(
              {
                'path' => '/etc/sysconfig/sa-update',
                'line' => %r{SAUPDATE=yes},
              },
            )
          }
        else
          it {
            is_expected.to contain_file_line('sa_update').with(
              {
                'path' => '/etc/default/spamassassin',
                'line' => %r{CRON=1},
              },
            )
          }
        end
      end

      describe 'with dkim enabled' do
        let(:params) { { dkim_enabled: true } }

        it {
          is_expected.to contain_package('dkim').with(
            ensure: 'installed',
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v312.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::DKIM},
            },
          )
        }
      end

      describe 'with pyzor enabled' do
        let(:params) { { pyzor_enabled: true } }

        it {
          is_expected.to contain_package('pyzor').with(
            ensure: 'installed',
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{use_pyzor           1},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::Pyzor},
            },
          )
        }

        it {
          is_expected.to contain_exec('pyzor_discover').with(
            command: "/usr/bin/pyzor --homedir '/etc/mail/spamassassin/.pyzor' discover",
            unless: 'test -d /etc/mail/spamassassin/.pyzor',
          )
        }
      end

      describe 'with razor enabled' do
        let(:params) { { razor_enabled: true } }

        it {
          is_expected.to contain_package('razor').with(
            ensure: 'installed',
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{use_razor2          1},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::Razor2},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/.razor').with(
            {
              'ensure' => 'directory',
            },
          )
        }

        it {
          is_expected.to contain_exec('razor_register').that_requires('File[/etc/mail/spamassassin/.razor]').with(
            command: '/usr/bin/razor-admin -home=/etc/mail/spamassassin/.razor -register',
            unless: 'test -h /etc/mail/spamassassin/.razor/identity',
          )
        }

        it {
          is_expected.to contain_exec('razor_create').that_requires('Exec[razor_register]').with(
            command: '/usr/bin/razor-admin -home=/etc/mail/spamassassin/.razor -create',
            creates: '/etc/mail/spamassassin/.razor/razor-agent.conf',
          )
        }

        it {
          is_expected.to contain_exec('razor_discover').that_requires('Exec[razor_create]').with(
            command: '/usr/bin/razor-admin -home=/etc/mail/spamassassin/.razor -discover',
            refreshonly: true,
          )
        }

        describe 'and razor_home set' do
          let(:params) do
            {
              razor_enabled: true,
              razor_home: '/tmp/foobar',
            }
          end

          it {
            is_expected.to contain_file('/tmp/foobar').with(
              {
                'ensure' => 'directory',
              },
            )
          }
        end

        describe 'and run_execs_as_user set' do
          let(:params) do
            {
              razor_enabled: true,
              run_execs_as_user: 'spamd',
            }
          end

          it {
            is_expected.to contain_exec('razor_register').with(
              {
                'user' => 'spamd',
                'cwd' => '/',
              },
            )
          }
        end
      end

      describe 'with shortcircuit enabled' do
        let(:params) { { shortcircuit_enabled: true } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{#   Some shortcircuiting},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v320.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::Shortcircuit},
            },
          )
        }
      end

      describe 'with rules2xsbody enabled' do
        let(:params) { { rules2xsbody_enabled: true } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v320.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::Rule2XSBody},
            },
          )
        }
      end

      describe 'with dcc enabled' do
        let(:params) { { dcc_enabled: true } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{use_dcc             1},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::DCC},
            },
          )
        }
      end

      describe 'with spamcop enabled' do
        let(:params) { { spamcop_enabled: true } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::SpamCop},
            },
          )
        }
      end

      describe 'with awl enabled' do
        let(:params) { { awl_enabled: true } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{use_auto_whitelist  1},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/v310.pre').with(
            {
              'content' => %r{^loadplugin Mail::SpamAssassin::Plugin::AWL},
            },
          )
        }
      end

      describe 'with userprefs sql' do
        let(:params) do
          {
            spamd_sql_config: true,
            user_scores_dsn: 'DBI:mysql:spamassassin:localhost:3306',
            user_scores_sql_username: 'sqluser',
            user_scores_sql_password: 'somesecret',
          }
        end

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/sql.cf').with(
            {
              'content' => %r{user_scores_dsn            DBI:mysql:spamassassin:localhost:3306},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/sql.cf').with(
            {
              'content' => %r{user_scores_sql_username   sqluser},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/sql.cf').with(
            {
              'content' => %r{user_scores_sql_password   somesecret},
            },
          )
        }
      end

      describe 'with bayes sql enabled' do
        let(:params) do
          {
            bayes_sql_enabled: true,
            bayes_sql_dsn: 'DBI:mysql:spamassassin:localhost:3306',
            bayes_sql_username: 'sqluser',
            bayes_sql_password: 'somesecret',
            bayes_store_module: 'Mail::SpamAssassin::BayesStore::PgSQL',
          }
        end

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{bayes_sql_dsn        DBI:mysql:spamassassin:localhost:3306},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{bayes_sql_username   sqluser},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{bayes_sql_password   somesecret},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{bayes_store_module   Mail::SpamAssassin::BayesStore::PgSQL},
            },
          )
        }
      end

      describe 'with score overrides' do
        let(:params) { { score_tests: { 'BAYES_00' => '-1.9', 'HTML_IMAGE_ONLY_28' => '1.40' } } }

        {
          'BAYES_00' => '-1.9',
          'HTML_IMAGE_ONLY_28' => '1.40',
        }.each_pair do |test, score|
          it {
            is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
              {
                'content' => %r{score #{test} #{score}},
              },
            )
          }
        end
      end

      describe 'with custom rules' do
        let(:params) { { custom_rules: { 'LOCAL_TEST' => { 'body' => '/this is spam/', 'score' => '5.0' } } } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{^body LOCAL_TEST /this is spam/$},
            },
          )
        }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').without(
            {
              'content' => %r{^header LOCAL_TEST},
            },
          )
        }
      end

      describe 'with custom config' do
        let(:params) { { custom_config: ['hashcash_accept *@example.com'] } }

        it {
          is_expected.to contain_file('/etc/mail/spamassassin/local.cf').with(
            {
              'content' => %r{^hashcash_accept \*@example.com$},
            },
          )
        }
      end
    end
  end
end
