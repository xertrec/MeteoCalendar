package org.udl

import org.apache.hc.client5.http.classic.methods.HttpGet
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse
import org.apache.hc.client5.http.impl.classic.HttpClients
import org.apache.hc.core5.http.io.entity.EntityUtils
import groovy.json.JsonSlurper

class NagerDateService {

    List<Map> getHolidaysForCurrentMonth(String countryCode, int year, int month) {
        CloseableHttpClient httpClient = HttpClients.createDefault()
        HttpGet request = new HttpGet("https://date.nager.at/api/v3/PublicHolidays/${year}/${countryCode}")
        request.addHeader("Accept", "application/json")
        try (CloseableHttpResponse response = httpClient.execute(request)) {
            String json = EntityUtils.toString(response.getEntity())
            def slurper = new JsonSlurper()
            def holidays = slurper.parseText(json) as List<Map>
            // Asegúrate de que el mes tenga dos dígitos
            String formattedMonth = String.format('%02d', month)
            return holidays.findAll { holiday ->
                holiday.date ==~ /${year}-${formattedMonth}-\d{2}/
            }
        } catch (Exception e) {
            log.error("Error al obtener las festividades: ${e.message}")
            return []
        }
    }
}
