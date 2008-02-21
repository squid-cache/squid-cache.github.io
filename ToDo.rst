This page just has a general TODO of various bogons noticed in squid.

 * internal requests - we change their protocol to HTTP in client_side, and then back to INTERNAL in client_side_reply. WTF.
 * delegate stuff like httpCachable to the request object, and from there to the URLScheme.
 * HTTP is considered unrevalidatable in client_side. Fixable by delegation to the protocol
 * why do we consider PUT requests to internal: etc servable ?
 * HTCP requests are not listed in the client db
 * ICP and HTCP are not protocols like the other protocols - split them out ?

= Wiki-related ToDo's =

 * Install [http://www.moinmo.in/ActionMarket/PdfAction PdfAction] - ["kinkie"]
 * Find a better way than th current 403s to handle crawlers trying to index wiki actions - ["kinkie"]
 * Enable interwiki synchronization (http://master.moinmo.in/HelpOnSynchronisation)
 * Properly register squid in InterWiki
 * Restructure the SquidFaq? - it would be nice to have automatic content indexing, and just use subpages
 * Add a reverse-proxy in front of the wiki
   * make moinmoin reverse-proxy friendlier (maybe it's just a matter of upgrading to version 1.6
 * upgrade to version 1.6 to get better search capabilities?
   * /!\ Notice: moin version 1.6 CHANGED the wiki syntax for most links and macros
 * [http://www.moinmo.in/MacroMarket/PageDicts PageDicts] would seem a nice way to auto-index FAQs and similar documents
