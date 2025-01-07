#!bin/bash

git pull origin develop
files_to_check=$(git diff --name-only develop... | grep .*.tex)

for file in $files_to_check
do
    # Rimozione dal file dei comandi e env che aspell non riconosce
    clean_file=$(cat $file | sed -e '/\\begin{lstlisting}/, /\\end{lstlisting}/d' -e 's/\\lstinline|[^|]*|//g' -e 's/\\lstinline+[^+]*+//g')

    # Esecuzione aspell sul file ripulito
    errors=$(echo "$clean_file" |  | aspell list --mode=tex --lang=it --home-dir=. --ignore-case --encoding=utf-8 --add-tex-command='label p' --add-tex-command='hyperref op' --add-tex-command='texttt p' --add-tex-command='dirtree p' --add-tex-command='href pp' --add-tex-command='ref p'| aspell list --lang=en --encoding=utf-8)

    for error in $errors
    do
        # Il file contiene almeno un errore
        #echo "## Il file $(basename $file) contiene i seguenti errori:" >> errori.md

        # Calcola il numero di riga in cui l'errore compare
        error_positions=$(sed -n '/'"$error"'/=' "$file")

        for pos in $error_positions
        do
            # Per ogni errore aggiunge al file errori.md un link all'errore
            echo "- [Rilevato errore $error alla riga $pos]($file/#L$pos)" >> errori.md
        done
    done
done