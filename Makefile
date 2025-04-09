CFLAGS=-g -Wall -Wextra `pkg-config --static --cflags kcgi-html kcgi-json sqlbox`
LDFLAGS=`pkg-config --static --libs kcgi-html kcgi-json sqlbox`
PBNIX_HTML=${HOME}/public_html/mellow
DESTDIR=/var/www/cgi-bin/mellow


all: edit query auth deauth signup database.db
install: install-noreplace install-db
install-pubnix: install-pubnix-noreplace install-db-pubnix
install-noreplace: install-edit install-auth install-deauth install-query install-signup
install-pubnix-noreplace: install-edit-pubnix install-auth-pubnix install-deauth-pubnix install-query-pubnix install-signup-pubnix

auth.o: src/auth.c
	${CC} ${CFLAGS} -c -o auth.o src/auth.c
auth: auth.o
	${CC} --static -o auth auth.o ${LDFLAGS}
install-auth-pubnix: auth
	install -m 0755 auth ${PBNIX_HTML}/auth.cgi
install-auth: auth
	install -o www -g www -m 0500 auth ${DESTDIR}/auth
clean-auth: auth.o auth
	rm auth
	rm auth.o


deauth.o: src/deauth.c
	${CC} ${CFLAGS} -c -o deauth.o src/deauth.c
deauth: deauth.o
	${CC} --static -o deauth deauth.o ${LDFLAGS}
install-deauth-pubnix: deauth
	install -m 0755 deauth ${PBNIX_HTML}/deauth.cgi
install-deauth: deauth
	install -o www -g www -m 0500 deauth ${DESTDIR}/deauth
clean-deauth: deauth.o deauth
	rm deauth
	rm deauth.o

edit.o: src/edit.c
	${CC} ${CFLAGS} -c -o edit.o src/edit.c
edit: edit.o
	${CC} --static -o edit edit.o ${LDFLAGS}
install-edit-pubnix: edit
	install -m 0755 edit ${PBNIX_HTML}/edit.cgi
install-edit: edit
	install -o www -g www -m 0500 edit ${DESTDIR}/edit
clean-edit: edit.o edit
	rm edit
	rm edit.o

query.o: src/query.c
	${CC} ${CFLAGS} -c -o query.o src/query.c
query: query.o
	${CC} --static -o query query.o ${LDFLAGS}
install-query-pubnix: query
	install -m 0755 query ${PBNIX_HTML}/query.cgi
install-query: query
	install -o www -g www -m 0500 query ${DESTDIR}/query
clean-query: query.o query
	rm query
	rm query.o

signup.o: src/signup.c
	${CC} ${CFLAGS} -c -o signup.o src/signup.c
signup: signup.o
	${CC} --static -o signup signup.o ${LDFLAGS}
install-signup-pubnix: signup
	install -m 0755 signup ${PBNIX_HTML}/signup.cgi
install-signup: signup
	install -o www -g www -m 0500 signup ${DESTDIR}/signup
clean-signup: signup.o signup
	rm signup
	rm signup.o

database.db: misc/database-scheme.sql
	[ -f database.db ] && rm database.db
	sqlite3 database.db < misc/database-scheme.sql
install-db-pubnix: database.db
	[ -d ${PBNIX_HTML}/db ] ||  mkdir -p ${PBNIX_HTML}/db
	install -m 0666 database.db ${PBNIX_HTML}/db
install-db: database.db
	[ -d ${DESTDIR}/db ] ||  mkdir -p ${DESTDIR}/db
	chown www:www ${DESTDIR}/db
	chmod 0700 ${DESTDIR}/db
	install -o www -g www -m 0600 database.db ${DESTDIR}/db
clean-db: database.db
	rm database.db

clean: clean-auth clean-deauth clean-db clean-edit clean-query clean-signup
