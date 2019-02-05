## v0.1.5

- remove `EctoCQS.Query.order_by/2` in favour of `Ecto.Query.where/3`

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
