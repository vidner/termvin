module main

import io
import net
import os
import rand

const (
	listen_port = 9999
	size_limit  = 4096
	slug_len    = 6
	domain_url  = 'http://localhost:8888'
)

fn handle_conn(mut socket net.TcpConn) {
	mut buf := io.read_all(reader: io.make_reader(socket)) or { return }
	mut nbytes := buf.len
	if buf.len > size_limit {
		nbytes = size_limit
	}
	mut slug := rand.string(slug_len)
	for {
		if os.exists('/tmp/$slug') {
			slug = rand.string(slug_len)
			continue
		} else {
			mut file := os.create('/tmp/$slug') or { return }
			file.write(buf[..nbytes]) or { panic(err) }
			file.close()
			socket.write_str('$domain_url/$slug\r\n') or { panic(err) }
			break
		}
	}
	socket.close() or { }
}

fn main() {
	mut server := net.listen_tcp(listen_port) or { panic(err) }

	for {
		mut new_conn := server.accept() or { continue }
		go handle_conn(mut new_conn)
	}

	server.close() or { }
}
