// Deterministic protocol fixture: tests Neovim's real LSP rendering, not a language server's analysis.
let pending = Buffer.alloc(0);
function send(data) {
  const body = JSON.stringify(data);
  process.stdout.write(`Content-Length: ${Buffer.byteLength(body)}\r\n\r\n${body}`);
}
function handle(m) {
  const result = m.method === 'initialize' ? { capabilities: {
    textDocumentSync: 1,
    semanticTokensProvider: { legend: { tokenTypes: ['variable'], tokenModifiers: ['readonly'] }, full: true },
    inlayHintProvider: true,
  } } : m.method === 'textDocument/semanticTokens/full' ? { data: [0, 6, 6, 0, 1] }
    : m.method === 'textDocument/inlayHint' ? [{ position: { line: 0, character: 12 }, label: ': integer', kind: 1 }]
    : null;
  if (m.id !== undefined) send({ jsonrpc: '2.0', id: m.id, result });
  if (m.method === 'textDocument/didOpen') send({ jsonrpc: '2.0', method: 'textDocument/publishDiagnostics', params: {
    uri: m.params.textDocument.uri, diagnostics: [{ range: { start: { line: 0, character: 6 }, end: { line: 0, character: 12 } }, severity: 2, message: 'W: fixture warning' }],
  } });
  if (m.method === 'exit') process.exit(0);
}
process.stdin.on('data', chunk => {
  pending = Buffer.concat([pending, chunk]);
  while (true) {
    const split = pending.indexOf('\r\n\r\n');
    if (split < 0) return;
    const length = Number(/Content-Length: (\d+)/i.exec(pending.subarray(0, split).toString())[1]);
    if (pending.length < split + 4 + length) return;
    const body = pending.subarray(split + 4, split + 4 + length);
    pending = pending.subarray(split + 4 + length);
    handle(JSON.parse(body));
  }
});
