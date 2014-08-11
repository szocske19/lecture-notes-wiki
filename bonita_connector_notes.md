Creating a New WS Connector
---------------------------

Source: <http://www-inf.int-evry.fr/cours/WebServices/TP_Workflow/publish_news.html>

Set the ``Content-Type``, ``application/soap+xml``

1. Write the following code:

    ```java
    import javax.xml.transform.dom.DOMSource;

    def output = (DOMSource) responseDocumentBody
    def ret = []
    def apps =
       output.getNode().
       childNodes.item(0).
       childNodes.item(1).
       childNodes.item(0).
       childNodes

    for (int i = 0; i < apps.length; i++) {
       ret.add(apps.item(i).textContent)
    }
    return ret
    ```

    Set the **Return type** to q ``java.util.List``.
    