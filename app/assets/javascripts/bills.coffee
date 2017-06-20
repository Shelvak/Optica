# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Bill =
  totals: {}

  calcRowAmount: (bi) ->
    row = $(bi)
    total = (parseInt(row.find('.js-bill-item-quantity').val()) || 1) *
      (parseFloat(row.find('.js-bill-item-amount').val()) || 0.0)

    row.find('.js-bill-item-total').html('$ ' + total.toFixed(2))
    Bill.totals[bi.id] = total.toFixed(2)

  calcAllRowsAmount: ()->
    Bill.totals = {}
    _.each($('fieldset.bill_item'), (bi)-> Bill.calcRowAmount(bi))

  calcTotalAmountAndVat: ()->
    total = _.reduce(Bill.totals, ((memo, value, index)-> memo + parseFloat(value)), 0.0)

    vat = parseFloat($('.js-bill-vat').val()) || 21.0

    $('.js-bill-total-amount').val(total.toFixed(2))
    $('.js-bill-total-vat').val((total * (vat / 100)).toFixed(2))

  recalcEverything: () ->
    Bill.calcAllRowsAmount()
    Bill.calcTotalAmountAndVat()

$(document).on 'change', '.bill_item input', Bill.recalcEverything
$(document).on 'dynamic-item.removed', Bill.recalcEverything

if ($('.bill_item input').length)
  Bill.recalcEverything()
