-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_240 is
end project_tb_240;

architecture project_tb_arch_240 of project_tb_240 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 501;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,76,0,148,0,19,0,52,0,83,0,112,0,202,0,16,0,243,0,115,0,0,0,0,0,199,0,160,0,113,0,63,0,89,0,236,0,123,0,220,0,0,0,16,0,176,0,0,0,0,0,37,0,0,0,62,0,44,0,221,0,0,0,0,0,128,0,36,0,0,0,0,0,219,0,205,0,107,0,161,0,0,0,109,0,12,0,0,0,95,0,196,0,0,0,231,0,253,0,112,0,0,0,54,0,217,0,149,0,193,0,207,0,0,0,124,0,0,0,138,0,129,0,202,0,65,0,142,0,117,0,96,0,152,0,221,0,105,0,34,0,233,0,215,0,185,0,14,0,118,0,231,0,69,0,44,0,68,0,214,0,245,0,252,0,0,0,203,0,25,0,164,0,0,0,33,0,64,0,12,0,243,0,209,0,0,0,255,0,28,0,100,0,0,0,248,0,0,0,202,0,57,0,224,0,229,0,7,0,232,0,130,0,161,0,220,0,205,0,227,0,88,0,0,0,155,0,64,0,251,0,0,0,31,0,40,0,107,0,174,0,154,0,123,0,22,0,250,0,0,0,43,0,242,0,0,0,9,0,183,0,158,0,201,0,173,0,53,0,116,0,31,0,0,0,42,0,0,0,122,0,0,0,139,0,252,0,27,0,24,0,23,0,214,0,67,0,119,0,179,0,103,0,65,0,51,0,156,0,0,0,72,0,211,0,179,0,64,0,0,0,164,0,127,0,75,0,143,0,244,0,163,0,23,0,0,0,16,0,78,0,192,0,116,0,32,0,239,0,12,0,17,0,227,0,207,0,7,0,0,0,48,0,119,0,136,0,223,0,5,0,203,0,243,0,250,0,32,0,90,0,44,0,0,0,98,0,80,0,0,0,193,0,190,0,7,0,214,0,185,0,111,0,6,0,108,0,217,0,81,0,122,0,252,0,41,0,169,0,121,0,0,0,91,0,43,0,127,0,24,0,0,0,57,0,61,0,97,0,189,0,134,0,0,0,92,0,177,0,0,0,0,0,242,0,0,0,70,0,211,0,20,0,0,0,0,0,193,0,0,0,21,0,97,0,72,0,57,0,0,0,0,0,189,0,136,0,0,0,158,0,209,0,146,0,0,0,5,0,5,0,7,0,2,0,184,0,0,0,44,0,18,0,157,0,116,0,11,0,201,0,158,0,203,0,140,0,112,0,180,0,232,0,7,0,3,0,94,0,46,0,0,0,0,0,134,0,105,0,38,0,182,0,111,0,226,0,130,0,180,0,29,0,224,0,151,0,0,0,242,0,147,0,0,0,143,0,104,0,47,0,0,0,0,0,0,0,0,0,160,0,225,0,255,0,189,0,144,0,205,0,123,0,65,0,0,0,130,0,0,0,29,0,114,0,0,0,144,0,103,0,58,0,0,0,144,0,0,0,26,0,170,0,0,0,0,0,0,0,0,0,182,0,9,0,155,0,230,0,83,0,62,0,190,0,12,0,165,0,103,0,234,0,223,0,87,0,48,0,48,0,177,0,47,0,199,0,18,0,118,0,114,0,123,0,204,0,248,0,0,0,125,0,222,0,61,0,58,0,164,0,249,0,177,0,46,0,0,0,139,0,210,0,54,0,194,0,20,0,0,0,248,0,179,0,0,0,9,0,170,0,119,0,170,0,0,0,0,0,249,0,251,0,17,0,38,0,17,0,88,0,192,0,109,0,0,0,238,0,0,0,183,0,0,0,19,0,97,0,15,0,102,0,99,0,229,0,180,0,208,0,251,0,0,0,0,0,0,0,249,0,0,0,212,0,214,0,117,0,241,0,140,0,78,0,0,0,200,0,53,0,0,0,19,0,101,0,50,0,241,0,137,0,65,0,45,0,226,0,63,0,187,0,202,0,187,0,34,0,161,0,38,0,237,0,0,0,0,0,32,0,40,0,109,0,16,0,190,0,153,0,155,0,241,0,27,0,230,0,177,0,41,0,173,0,143,0,210,0,0,0,9,0,93,0,0,0,28,0,11,0,111,0,110,0,134,0,141,0,112,0,42,0,162,0,118,0,246,0,112,0,46,0,43,0,27,0,225,0,61,0,156,0,0,0,155,0,201,0,247,0,222,0,55,0,142,0,217,0,134,0,114,0,166,0,129,0,0,0,77,0,41,0,245,0,51,0,118,0,136,0,105,0,152,0,0,0,124,0,173,0,19,0,245,0,226,0,255,0,133,0,211,0,184,0,199,0,252,0,45,0,246,0,12,0,98,0,178,0,0,0);
signal scenario_full  : scenario_type := (0,0,76,31,148,31,19,31,52,31,83,31,112,31,202,31,16,31,243,31,115,31,115,30,115,29,199,31,160,31,113,31,63,31,89,31,236,31,123,31,220,31,220,30,16,31,176,31,176,30,176,29,37,31,37,30,62,31,44,31,221,31,221,30,221,29,128,31,36,31,36,30,36,29,219,31,205,31,107,31,161,31,161,30,109,31,12,31,12,30,95,31,196,31,196,30,231,31,253,31,112,31,112,30,54,31,217,31,149,31,193,31,207,31,207,30,124,31,124,30,138,31,129,31,202,31,65,31,142,31,117,31,96,31,152,31,221,31,105,31,34,31,233,31,215,31,185,31,14,31,118,31,231,31,69,31,44,31,68,31,214,31,245,31,252,31,252,30,203,31,25,31,164,31,164,30,33,31,64,31,12,31,243,31,209,31,209,30,255,31,28,31,100,31,100,30,248,31,248,30,202,31,57,31,224,31,229,31,7,31,232,31,130,31,161,31,220,31,205,31,227,31,88,31,88,30,155,31,64,31,251,31,251,30,31,31,40,31,107,31,174,31,154,31,123,31,22,31,250,31,250,30,43,31,242,31,242,30,9,31,183,31,158,31,201,31,173,31,53,31,116,31,31,31,31,30,42,31,42,30,122,31,122,30,139,31,252,31,27,31,24,31,23,31,214,31,67,31,119,31,179,31,103,31,65,31,51,31,156,31,156,30,72,31,211,31,179,31,64,31,64,30,164,31,127,31,75,31,143,31,244,31,163,31,23,31,23,30,16,31,78,31,192,31,116,31,32,31,239,31,12,31,17,31,227,31,207,31,7,31,7,30,48,31,119,31,136,31,223,31,5,31,203,31,243,31,250,31,32,31,90,31,44,31,44,30,98,31,80,31,80,30,193,31,190,31,7,31,214,31,185,31,111,31,6,31,108,31,217,31,81,31,122,31,252,31,41,31,169,31,121,31,121,30,91,31,43,31,127,31,24,31,24,30,57,31,61,31,97,31,189,31,134,31,134,30,92,31,177,31,177,30,177,29,242,31,242,30,70,31,211,31,20,31,20,30,20,29,193,31,193,30,21,31,97,31,72,31,57,31,57,30,57,29,189,31,136,31,136,30,158,31,209,31,146,31,146,30,5,31,5,31,7,31,2,31,184,31,184,30,44,31,18,31,157,31,116,31,11,31,201,31,158,31,203,31,140,31,112,31,180,31,232,31,7,31,3,31,94,31,46,31,46,30,46,29,134,31,105,31,38,31,182,31,111,31,226,31,130,31,180,31,29,31,224,31,151,31,151,30,242,31,147,31,147,30,143,31,104,31,47,31,47,30,47,29,47,28,47,27,160,31,225,31,255,31,189,31,144,31,205,31,123,31,65,31,65,30,130,31,130,30,29,31,114,31,114,30,144,31,103,31,58,31,58,30,144,31,144,30,26,31,170,31,170,30,170,29,170,28,170,27,182,31,9,31,155,31,230,31,83,31,62,31,190,31,12,31,165,31,103,31,234,31,223,31,87,31,48,31,48,31,177,31,47,31,199,31,18,31,118,31,114,31,123,31,204,31,248,31,248,30,125,31,222,31,61,31,58,31,164,31,249,31,177,31,46,31,46,30,139,31,210,31,54,31,194,31,20,31,20,30,248,31,179,31,179,30,9,31,170,31,119,31,170,31,170,30,170,29,249,31,251,31,17,31,38,31,17,31,88,31,192,31,109,31,109,30,238,31,238,30,183,31,183,30,19,31,97,31,15,31,102,31,99,31,229,31,180,31,208,31,251,31,251,30,251,29,251,28,249,31,249,30,212,31,214,31,117,31,241,31,140,31,78,31,78,30,200,31,53,31,53,30,19,31,101,31,50,31,241,31,137,31,65,31,45,31,226,31,63,31,187,31,202,31,187,31,34,31,161,31,38,31,237,31,237,30,237,29,32,31,40,31,109,31,16,31,190,31,153,31,155,31,241,31,27,31,230,31,177,31,41,31,173,31,143,31,210,31,210,30,9,31,93,31,93,30,28,31,11,31,111,31,110,31,134,31,141,31,112,31,42,31,162,31,118,31,246,31,112,31,46,31,43,31,27,31,225,31,61,31,156,31,156,30,155,31,201,31,247,31,222,31,55,31,142,31,217,31,134,31,114,31,166,31,129,31,129,30,77,31,41,31,245,31,51,31,118,31,136,31,105,31,152,31,152,30,124,31,173,31,19,31,245,31,226,31,255,31,133,31,211,31,184,31,199,31,252,31,45,31,246,31,12,31,98,31,178,31,178,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
