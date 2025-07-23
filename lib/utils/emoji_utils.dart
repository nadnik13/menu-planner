String getEmojiForMeal(String title) {
  final t = title.toLowerCase();
  if (t.contains('суп') ||
      t.contains('борщ') ||
      t.contains('щи') ||
      t.contains('бульон') ||
      t.contains('чечевич') ||
      t.contains('грибн') ||
      t.contains('курин') && t.contains('суп') ||
      t.contains('горох') ||
      t.contains('солянк') ||
      t.contains('харчо') ||
      t.contains('минестроне') ||
      t.contains('пюре') && t.contains('суп'))
    return '🍲';
  if (t.contains('овсянк') ||
      t.contains('каша') ||
      t.contains('мюсли') ||
      t.contains('гранол'))
    return '🥣';
  if (t.contains('яйц') || t.contains('омлет')) return '🍳';
  if (t.contains('котлет') || t.contains('фрикадель') || t.contains('тефтел'))
    return '🧆';
  if (t.contains('рагу') || t.contains('жаркое') || t.contains('туш'))
    return '🥘';
  if (t.contains('паста') || t.contains('макарон') || t.contains('лазан'))
    return '🍝';
  if (t.contains('рис') || t.contains('плов')) return '🍚';
  if (t.contains('картоф') || t.contains('пюре')) return '🥔';

  if (t.contains('десерт') ||
      t.contains('панна') ||
      t.contains('торт') ||
      t.contains('чизкейк'))
    return '🍰';
  if (t.contains('банан')) return '🍌';
  if (t.contains('яблок')) return '🍏';
  if (t.contains('тост') || t.contains('хлеб') || t.contains('бутер'))
    return '🍞';
  if (t.contains('орех') || t.contains('арахис')) return '🥜';
  if (t.contains('запеканк') || t.contains('кекс') || t.contains('маффин'))
    return '🧁';
  if (t.contains('йогурт') || t.contains('кефир') || t.contains('молоко'))
    return '🥛';

  if (t.contains('салат') ||
      t.contains('огурец') ||
      t.contains('помидор') ||
      t.contains('капуст'))
    return '🥗';
  if (t.contains('томат') || t.contains('помидор')) return '🍅';
  if (t.contains('огурец')) return '🥒';
  if (t.contains('чеснок') || t.contains('лук')) return '🧄';
  if (t.contains('морков') || t.contains('батат') || t.contains('корнеплод'))
    return '🍠';
  if (t.contains('баклажан')) return '🍆';
  if (t.contains('перец')) return '🫑';
  if (t.contains('зелень') || t.contains('шпинат')) return '🥬';

  if (t.contains('куриц')) return '🍗';
  if (t.contains('говядин') ||
      t.contains('свинин') ||
      t.contains('щечк') ||
      t.contains('мяс'))
    return '🍖';

  if (t.contains('печен') || t.contains('пряник')) return '🍪';
  if (t.contains('шоколад') || t.contains('брауни')) return '🍫';

  if (t.contains('чай') || t.contains('компот') || t.contains('отвар'))
    return '🍵';
  if (t.contains('смузи') || t.contains('сок') || t.contains('напит'))
    return '🧃';

  if (t.contains('заготовк') || t.contains('контейнер') || t.contains('ланч'))
    return '🍱';
  if (t.contains('замороз')) return '🧊';

  return '';
}
