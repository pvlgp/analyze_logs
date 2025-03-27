#!/bin/bash

echo "Отчет о логе веб-сервера" > report.txt
echo "========================" >> report.txt

# Подсчет общего количества запросов
number_of_requests=0
while read -r line; do
    number_of_requests=$((number_of_requests + 1))
done < access.log

echo "Общее количество запросов: $number_of_requests" >> report.txt

# Подсчет количества уникальных IP адресов
awk '!seen[$1]++ { unique++ } END { print "Количество количества уникальных IP адресов: ", unique }' access.log >> report.txt

echo -e "\nКоличество запросов по методам:" >> report.txt
awk '/GET/ { count++ } END { print "    ", count, " GET" }' access.log >> report.txt
awk '/POST/ { count++ } END { print "    ", count, " POST" }' access.log >> report.txt

# самый популярный URL
awk '
    { requests[$7]++ }
END {
    max=0
    for (request in requests) {
        if (requests[request] > max) {
            max=requests[request]
            most_popular=request
        }
    }
    print "Самый популярный URL: ", requests[most_popular], " ", most_popular
}
' access.log >> report.txt