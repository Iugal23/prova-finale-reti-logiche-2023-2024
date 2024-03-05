-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 403;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (46,0,98,0,133,0,109,0,214,0,199,0,0,0,78,0,221,0,15,0,0,0,14,0,126,0,39,0,22,0,89,0,160,0,0,0,52,0,62,0,73,0,0,0,190,0,0,0,209,0,244,0,67,0,146,0,105,0,90,0,0,0,247,0,122,0,115,0,208,0,152,0,63,0,199,0,176,0,11,0,142,0,136,0,58,0,217,0,112,0,147,0,101,0,0,0,106,0,60,0,108,0,114,0,45,0,0,0,0,0,135,0,47,0,125,0,21,0,0,0,95,0,172,0,66,0,0,0,80,0,221,0,24,0,9,0,48,0,175,0,174,0,221,0,0,0,89,0,65,0,174,0,0,0,244,0,147,0,191,0,0,0,73,0,0,0,213,0,0,0,157,0,157,0,151,0,11,0,150,0,0,0,187,0,0,0,21,0,0,0,201,0,235,0,141,0,144,0,5,0,18,0,7,0,187,0,166,0,230,0,0,0,199,0,192,0,241,0,0,0,73,0,140,0,0,0,244,0,224,0,98,0,0,0,246,0,27,0,63,0,149,0,128,0,0,0,0,0,172,0,58,0,17,0,199,0,211,0,0,0,0,0,30,0,85,0,67,0,72,0,102,0,252,0,242,0,0,0,224,0,213,0,225,0,202,0,3,0,46,0,122,0,169,0,48,0,125,0,21,0,11,0,233,0,223,0,203,0,172,0,139,0,0,0,129,0,218,0,41,0,74,0,111,0,0,0,0,0,221,0,235,0,182,0,0,0,220,0,0,0,179,0,189,0,33,0,14,0,61,0,40,0,144,0,0,0,126,0,0,0,0,0,0,0,206,0,107,0,158,0,97,0,0,0,149,0,7,0,183,0,3,0,0,0,62,0,131,0,19,0,101,0,250,0,76,0,148,0,255,0,194,0,125,0,0,0,0,0,151,0,239,0,140,0,79,0,108,0,59,0,234,0,146,0,108,0,199,0,87,0,0,0,211,0,249,0,156,0,102,0,222,0,62,0,0,0,159,0,187,0,194,0,45,0,238,0,122,0,43,0,35,0,76,0,63,0,12,0,224,0,245,0,67,0,0,0,0,0,241,0,252,0,240,0,230,0,0,0,42,0,7,0,0,0,41,0,191,0,0,0,79,0,159,0,230,0,0,0,161,0,249,0,181,0,165,0,220,0,102,0,158,0,61,0,21,0,7,0,230,0,117,0,217,0,170,0,0,0,174,0,0,0,50,0,97,0,235,0,193,0,53,0,169,0,0,0,0,0,118,0,227,0,134,0,53,0,215,0,169,0,0,0,155,0,90,0,242,0,0,0,127,0,71,0,2,0,0,0,13,0,229,0,143,0,102,0,214,0,255,0,90,0,0,0,23,0,126,0,102,0,223,0,141,0,215,0,4,0,24,0,189,0,220,0,38,0,0,0,252,0,141,0,152,0,173,0,2,0,0,0,103,0,77,0,215,0,248,0,84,0,218,0,0,0,0,0,22,0,0,0,66,0,107,0,154,0,217,0,0,0,134,0,54,0,0,0,164,0,0,0,24,0,31,0,40,0,0,0,8,0,0,0,0,0,203,0,230,0,8,0,0,0,0,0,68,0,72,0,198,0,209,0,167,0,91,0,180,0,223,0,0,0,186,0,135,0,152,0,138,0,36,0,55,0,94,0,0,0,128,0,226,0,0,0,68,0,184,0,147,0,0,0,216,0,152,0,0,0,77,0,81,0,5,0,0,0,127,0,42,0,240,0,129,0,41,0,100,0,230,0,187,0,65,0,249,0,187,0,146,0,237,0,39,0,168,0,5,0,155,0,23,0,248,0,0,0);
signal scenario_full  : scenario_type := (46,31,98,31,133,31,109,31,214,31,199,31,199,30,78,31,221,31,15,31,15,30,14,31,126,31,39,31,22,31,89,31,160,31,160,30,52,31,62,31,73,31,73,30,190,31,190,30,209,31,244,31,67,31,146,31,105,31,90,31,90,30,247,31,122,31,115,31,208,31,152,31,63,31,199,31,176,31,11,31,142,31,136,31,58,31,217,31,112,31,147,31,101,31,101,30,106,31,60,31,108,31,114,31,45,31,45,30,45,29,135,31,47,31,125,31,21,31,21,30,95,31,172,31,66,31,66,30,80,31,221,31,24,31,9,31,48,31,175,31,174,31,221,31,221,30,89,31,65,31,174,31,174,30,244,31,147,31,191,31,191,30,73,31,73,30,213,31,213,30,157,31,157,31,151,31,11,31,150,31,150,30,187,31,187,30,21,31,21,30,201,31,235,31,141,31,144,31,5,31,18,31,7,31,187,31,166,31,230,31,230,30,199,31,192,31,241,31,241,30,73,31,140,31,140,30,244,31,224,31,98,31,98,30,246,31,27,31,63,31,149,31,128,31,128,30,128,29,172,31,58,31,17,31,199,31,211,31,211,30,211,29,30,31,85,31,67,31,72,31,102,31,252,31,242,31,242,30,224,31,213,31,225,31,202,31,3,31,46,31,122,31,169,31,48,31,125,31,21,31,11,31,233,31,223,31,203,31,172,31,139,31,139,30,129,31,218,31,41,31,74,31,111,31,111,30,111,29,221,31,235,31,182,31,182,30,220,31,220,30,179,31,189,31,33,31,14,31,61,31,40,31,144,31,144,30,126,31,126,30,126,29,126,28,206,31,107,31,158,31,97,31,97,30,149,31,7,31,183,31,3,31,3,30,62,31,131,31,19,31,101,31,250,31,76,31,148,31,255,31,194,31,125,31,125,30,125,29,151,31,239,31,140,31,79,31,108,31,59,31,234,31,146,31,108,31,199,31,87,31,87,30,211,31,249,31,156,31,102,31,222,31,62,31,62,30,159,31,187,31,194,31,45,31,238,31,122,31,43,31,35,31,76,31,63,31,12,31,224,31,245,31,67,31,67,30,67,29,241,31,252,31,240,31,230,31,230,30,42,31,7,31,7,30,41,31,191,31,191,30,79,31,159,31,230,31,230,30,161,31,249,31,181,31,165,31,220,31,102,31,158,31,61,31,21,31,7,31,230,31,117,31,217,31,170,31,170,30,174,31,174,30,50,31,97,31,235,31,193,31,53,31,169,31,169,30,169,29,118,31,227,31,134,31,53,31,215,31,169,31,169,30,155,31,90,31,242,31,242,30,127,31,71,31,2,31,2,30,13,31,229,31,143,31,102,31,214,31,255,31,90,31,90,30,23,31,126,31,102,31,223,31,141,31,215,31,4,31,24,31,189,31,220,31,38,31,38,30,252,31,141,31,152,31,173,31,2,31,2,30,103,31,77,31,215,31,248,31,84,31,218,31,218,30,218,29,22,31,22,30,66,31,107,31,154,31,217,31,217,30,134,31,54,31,54,30,164,31,164,30,24,31,31,31,40,31,40,30,8,31,8,30,8,29,203,31,230,31,8,31,8,30,8,29,68,31,72,31,198,31,209,31,167,31,91,31,180,31,223,31,223,30,186,31,135,31,152,31,138,31,36,31,55,31,94,31,94,30,128,31,226,31,226,30,68,31,184,31,147,31,147,30,216,31,152,31,152,30,77,31,81,31,5,31,5,30,127,31,42,31,240,31,129,31,41,31,100,31,230,31,187,31,65,31,249,31,187,31,146,31,237,31,39,31,168,31,5,31,155,31,23,31,248,31,248,30);

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
