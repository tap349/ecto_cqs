## v0.6.0

- add `EctoCQS.Mutator.multi_insert_all/3`

## v0.5.0

- allow to override `EctoCQS.Loader.default_scope/0`

## v0.4.1

- add `EctoCQS.Mutator.multi_update/2`

## v0.4.0

- remove `EctoCQS.SchemaHelpers` module - I'm going to extract these and
  other helpers into their own package

## v0.3.2

- fixes of `EctoCQS.SchemaHelpers.cast/1` to make it work for both insert
  and update operations

## v0.3.1

- move `EctoCQS.Mutator.cast/2` to `EctoCQS.SchemaHelpers.cast/1`

## v0.3.0

- add `EctoCQS.Mutator.cast/2`

## v0.2.1

- `EctoCQS.Mutator.multi_insert/2` allows to insert not only changesets but
  entries as well

## v0.2.0

- add `EctoCQS.Mutator.multi_insert/2`
- rename `EctoCQS.Mutator.create/1` to `EctoCQS.Mutator.insert/2` and allow
  to pass options (hence arity of 2)

## v0.1.9

- add `EctoCQS.Loader.first/1` and `EctoCQS.Loader.last/1`

## v0.1.8

- add `EctoCQS.Loader.count_by/1`

## v0.1.5

- remove `EctoCQS.Query.by/2` in favour of `Ecto.Query.where/3`

## v0.1.4

- fix bug in EctoCQS.Loader

## v0.1.3

- remove `EctoCQS.Query.order_by/2` and `EctoCQS.Query.limit/2` in favour
  of `Ecto.Query.order_by/3` and `Ecto.Query.limit/2`

## v0.1.2

- rename `EctoCQS.Mutator.import/2` to `EctoCQS.Mutator.insert_all/3` to avoid
  possible name conflicts with `Kernel.SpecialForms.import/2`

## v0.1.0

- Initial release
