-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_58 is
end project_tb_58;

architecture project_tb_arch_58 of project_tb_58 is
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

constant SCENARIO_LENGTH : integer := 408;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,135,0,0,0,0,0,0,0,176,0,84,0,32,0,61,0,89,0,0,0,28,0,244,0,115,0,0,0,96,0,39,0,13,0,185,0,116,0,0,0,101,0,201,0,68,0,74,0,167,0,65,0,0,0,243,0,0,0,143,0,196,0,0,0,65,0,228,0,0,0,130,0,23,0,40,0,122,0,128,0,105,0,4,0,202,0,222,0,236,0,133,0,124,0,159,0,140,0,0,0,196,0,103,0,12,0,39,0,190,0,208,0,0,0,224,0,0,0,36,0,84,0,186,0,0,0,126,0,0,0,76,0,212,0,58,0,242,0,199,0,116,0,107,0,0,0,60,0,223,0,14,0,0,0,221,0,18,0,162,0,4,0,233,0,246,0,254,0,52,0,218,0,21,0,63,0,166,0,174,0,28,0,0,0,241,0,152,0,222,0,70,0,232,0,163,0,0,0,216,0,0,0,45,0,81,0,40,0,243,0,85,0,224,0,60,0,0,0,117,0,153,0,25,0,200,0,24,0,0,0,47,0,140,0,0,0,107,0,101,0,0,0,61,0,0,0,177,0,147,0,0,0,0,0,56,0,96,0,182,0,0,0,236,0,1,0,226,0,23,0,0,0,0,0,0,0,0,0,72,0,38,0,152,0,0,0,183,0,21,0,0,0,217,0,27,0,255,0,121,0,134,0,107,0,208,0,20,0,238,0,110,0,3,0,189,0,89,0,94,0,70,0,174,0,0,0,0,0,63,0,19,0,141,0,0,0,41,0,49,0,66,0,149,0,149,0,233,0,192,0,0,0,0,0,0,0,171,0,47,0,55,0,49,0,182,0,122,0,92,0,0,0,127,0,245,0,140,0,205,0,0,0,88,0,5,0,95,0,41,0,72,0,0,0,73,0,177,0,140,0,0,0,0,0,221,0,38,0,207,0,227,0,170,0,60,0,48,0,128,0,0,0,0,0,131,0,0,0,254,0,77,0,102,0,243,0,198,0,0,0,32,0,192,0,49,0,117,0,0,0,222,0,42,0,0,0,233,0,138,0,132,0,69,0,0,0,148,0,0,0,0,0,118,0,102,0,121,0,195,0,224,0,181,0,164,0,20,0,128,0,17,0,129,0,0,0,188,0,202,0,112,0,215,0,241,0,66,0,58,0,0,0,172,0,149,0,0,0,116,0,197,0,112,0,118,0,0,0,182,0,200,0,236,0,0,0,195,0,25,0,173,0,0,0,238,0,5,0,54,0,190,0,0,0,0,0,118,0,57,0,0,0,11,0,244,0,187,0,26,0,81,0,71,0,35,0,246,0,175,0,0,0,75,0,0,0,0,0,216,0,0,0,41,0,166,0,0,0,226,0,119,0,62,0,112,0,78,0,245,0,255,0,181,0,189,0,55,0,249,0,78,0,111,0,124,0,0,0,9,0,92,0,224,0,207,0,0,0,26,0,183,0,135,0,0,0,28,0,14,0,151,0,133,0,242,0,234,0,248,0,0,0,48,0,224,0,185,0,0,0,43,0,17,0,50,0,113,0,242,0,117,0,105,0,186,0,144,0,0,0,197,0,0,0,0,0,148,0,232,0,45,0,252,0,54,0,231,0,104,0,0,0,84,0,212,0,90,0,151,0,132,0,159,0,193,0,0,0,250,0,232,0,199,0,221,0,136,0,189,0,58,0,158,0,162,0,186,0,0,0,0,0,76,0,0,0,34,0,0,0,128,0,5,0,52,0,0,0,181,0,0,0,221,0,0,0,126,0,208,0,224,0,0,0,81,0,44,0,223,0,0,0,138,0,135,0,227,0,78,0,22,0,158,0,68,0,181,0,0,0,109,0,112,0);
signal scenario_full  : scenario_type := (0,0,135,31,135,30,135,29,135,28,176,31,84,31,32,31,61,31,89,31,89,30,28,31,244,31,115,31,115,30,96,31,39,31,13,31,185,31,116,31,116,30,101,31,201,31,68,31,74,31,167,31,65,31,65,30,243,31,243,30,143,31,196,31,196,30,65,31,228,31,228,30,130,31,23,31,40,31,122,31,128,31,105,31,4,31,202,31,222,31,236,31,133,31,124,31,159,31,140,31,140,30,196,31,103,31,12,31,39,31,190,31,208,31,208,30,224,31,224,30,36,31,84,31,186,31,186,30,126,31,126,30,76,31,212,31,58,31,242,31,199,31,116,31,107,31,107,30,60,31,223,31,14,31,14,30,221,31,18,31,162,31,4,31,233,31,246,31,254,31,52,31,218,31,21,31,63,31,166,31,174,31,28,31,28,30,241,31,152,31,222,31,70,31,232,31,163,31,163,30,216,31,216,30,45,31,81,31,40,31,243,31,85,31,224,31,60,31,60,30,117,31,153,31,25,31,200,31,24,31,24,30,47,31,140,31,140,30,107,31,101,31,101,30,61,31,61,30,177,31,147,31,147,30,147,29,56,31,96,31,182,31,182,30,236,31,1,31,226,31,23,31,23,30,23,29,23,28,23,27,72,31,38,31,152,31,152,30,183,31,21,31,21,30,217,31,27,31,255,31,121,31,134,31,107,31,208,31,20,31,238,31,110,31,3,31,189,31,89,31,94,31,70,31,174,31,174,30,174,29,63,31,19,31,141,31,141,30,41,31,49,31,66,31,149,31,149,31,233,31,192,31,192,30,192,29,192,28,171,31,47,31,55,31,49,31,182,31,122,31,92,31,92,30,127,31,245,31,140,31,205,31,205,30,88,31,5,31,95,31,41,31,72,31,72,30,73,31,177,31,140,31,140,30,140,29,221,31,38,31,207,31,227,31,170,31,60,31,48,31,128,31,128,30,128,29,131,31,131,30,254,31,77,31,102,31,243,31,198,31,198,30,32,31,192,31,49,31,117,31,117,30,222,31,42,31,42,30,233,31,138,31,132,31,69,31,69,30,148,31,148,30,148,29,118,31,102,31,121,31,195,31,224,31,181,31,164,31,20,31,128,31,17,31,129,31,129,30,188,31,202,31,112,31,215,31,241,31,66,31,58,31,58,30,172,31,149,31,149,30,116,31,197,31,112,31,118,31,118,30,182,31,200,31,236,31,236,30,195,31,25,31,173,31,173,30,238,31,5,31,54,31,190,31,190,30,190,29,118,31,57,31,57,30,11,31,244,31,187,31,26,31,81,31,71,31,35,31,246,31,175,31,175,30,75,31,75,30,75,29,216,31,216,30,41,31,166,31,166,30,226,31,119,31,62,31,112,31,78,31,245,31,255,31,181,31,189,31,55,31,249,31,78,31,111,31,124,31,124,30,9,31,92,31,224,31,207,31,207,30,26,31,183,31,135,31,135,30,28,31,14,31,151,31,133,31,242,31,234,31,248,31,248,30,48,31,224,31,185,31,185,30,43,31,17,31,50,31,113,31,242,31,117,31,105,31,186,31,144,31,144,30,197,31,197,30,197,29,148,31,232,31,45,31,252,31,54,31,231,31,104,31,104,30,84,31,212,31,90,31,151,31,132,31,159,31,193,31,193,30,250,31,232,31,199,31,221,31,136,31,189,31,58,31,158,31,162,31,186,31,186,30,186,29,76,31,76,30,34,31,34,30,128,31,5,31,52,31,52,30,181,31,181,30,221,31,221,30,126,31,208,31,224,31,224,30,81,31,44,31,223,31,223,30,138,31,135,31,227,31,78,31,22,31,158,31,68,31,181,31,181,30,109,31,112,31);

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
