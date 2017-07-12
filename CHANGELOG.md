# CHANGELOG

##### Changelog v2.0.0 28/04/2017:

- Improve code of recipes and helpers according to Ruby Style Guide.

- `Tomcat` module and `getTomcatFolder` method changed its names to `TomcatService` and `get_folder` respectively.

- New module `Url` with `is_reachable?` method.

- New resource `ruby_block 'Test Tomcat Manager Configuration'` added in `default.rb` recipe.

- New variables added to manage the flow of process.

#### Changelog v1.1.1 12/10/2016:

- Change behavior of `windows_service Tomcat7` resource. Now, Tomcat7 will be restarted after editing the files.

- Delete `ignore_failure` attribute from Tomcat7 resource. It caused problems in the deployment.

- Change default `timeout` from 60 to 180 in `windows_service Tomcat7` resource.
