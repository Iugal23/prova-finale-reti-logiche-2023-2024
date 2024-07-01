-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_813 is
end project_tb_813;

architecture project_tb_arch_813 of project_tb_813 is
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

constant SCENARIO_LENGTH : integer := 616;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,64,0,73,0,245,0,0,0,80,0,0,0,162,0,45,0,131,0,68,0,104,0,90,0,0,0,94,0,204,0,194,0,8,0,120,0,195,0,65,0,234,0,0,0,0,0,142,0,0,0,30,0,6,0,89,0,52,0,3,0,0,0,0,0,153,0,16,0,12,0,131,0,173,0,130,0,236,0,130,0,173,0,189,0,53,0,151,0,187,0,97,0,0,0,180,0,191,0,136,0,253,0,79,0,140,0,121,0,0,0,0,0,70,0,125,0,208,0,224,0,96,0,81,0,72,0,22,0,6,0,164,0,237,0,31,0,181,0,224,0,94,0,142,0,85,0,191,0,79,0,110,0,0,0,238,0,0,0,0,0,86,0,0,0,84,0,110,0,15,0,172,0,255,0,125,0,91,0,49,0,24,0,39,0,101,0,21,0,214,0,206,0,123,0,173,0,0,0,61,0,128,0,243,0,55,0,239,0,0,0,73,0,152,0,0,0,163,0,247,0,106,0,133,0,142,0,125,0,8,0,249,0,218,0,75,0,23,0,218,0,0,0,68,0,196,0,102,0,0,0,24,0,0,0,155,0,226,0,23,0,15,0,204,0,238,0,30,0,0,0,243,0,84,0,231,0,174,0,195,0,90,0,212,0,0,0,217,0,0,0,221,0,222,0,90,0,85,0,0,0,207,0,18,0,233,0,0,0,42,0,4,0,0,0,219,0,130,0,186,0,162,0,0,0,97,0,84,0,131,0,81,0,0,0,0,0,9,0,0,0,7,0,0,0,197,0,96,0,175,0,0,0,43,0,185,0,48,0,191,0,17,0,211,0,199,0,0,0,194,0,0,0,0,0,47,0,0,0,0,0,166,0,133,0,90,0,25,0,135,0,165,0,125,0,245,0,193,0,0,0,134,0,183,0,137,0,149,0,0,0,87,0,74,0,135,0,0,0,108,0,190,0,151,0,237,0,199,0,181,0,89,0,176,0,0,0,248,0,19,0,73,0,175,0,0,0,219,0,156,0,246,0,0,0,0,0,77,0,198,0,215,0,159,0,0,0,33,0,0,0,186,0,163,0,3,0,26,0,0,0,211,0,7,0,113,0,181,0,208,0,131,0,65,0,185,0,95,0,102,0,241,0,76,0,0,0,131,0,47,0,99,0,194,0,108,0,0,0,18,0,238,0,162,0,0,0,0,0,27,0,4,0,167,0,24,0,47,0,193,0,181,0,130,0,102,0,42,0,73,0,244,0,245,0,0,0,221,0,0,0,0,0,102,0,155,0,0,0,219,0,11,0,40,0,184,0,21,0,108,0,0,0,129,0,186,0,208,0,140,0,16,0,170,0,179,0,138,0,230,0,0,0,14,0,255,0,165,0,101,0,159,0,89,0,241,0,5,0,90,0,0,0,22,0,0,0,37,0,37,0,144,0,30,0,252,0,156,0,183,0,143,0,0,0,0,0,118,0,252,0,0,0,114,0,75,0,174,0,72,0,157,0,167,0,40,0,0,0,0,0,225,0,0,0,0,0,144,0,252,0,242,0,17,0,0,0,250,0,0,0,120,0,2,0,182,0,201,0,74,0,158,0,0,0,0,0,81,0,149,0,0,0,14,0,22,0,41,0,0,0,173,0,122,0,232,0,0,0,32,0,0,0,141,0,186,0,187,0,76,0,220,0,32,0,52,0,0,0,0,0,245,0,162,0,107,0,244,0,13,0,103,0,45,0,0,0,129,0,203,0,0,0,65,0,10,0,18,0,251,0,187,0,60,0,130,0,127,0,149,0,0,0,150,0,161,0,140,0,57,0,248,0,107,0,215,0,250,0,59,0,0,0,198,0,18,0,238,0,209,0,91,0,101,0,48,0,50,0,0,0,218,0,231,0,42,0,164,0,104,0,200,0,0,0,0,0,160,0,26,0,208,0,6,0,119,0,90,0,39,0,0,0,135,0,58,0,152,0,194,0,84,0,109,0,183,0,171,0,0,0,0,0,157,0,163,0,0,0,0,0,90,0,239,0,0,0,121,0,250,0,213,0,0,0,231,0,67,0,0,0,0,0,45,0,110,0,228,0,12,0,66,0,81,0,62,0,123,0,0,0,102,0,81,0,143,0,140,0,164,0,205,0,0,0,1,0,86,0,102,0,0,0,0,0,133,0,0,0,151,0,166,0,40,0,19,0,152,0,0,0,0,0,79,0,0,0,83,0,0,0,0,0,108,0,161,0,68,0,81,0,97,0,68,0,78,0,210,0,221,0,71,0,15,0,173,0,87,0,103,0,15,0,0,0,196,0,0,0,227,0,0,0,151,0,72,0,141,0,135,0,29,0,114,0,77,0,142,0,229,0,123,0,116,0,0,0,203,0,200,0,63,0,45,0,17,0,146,0,82,0,0,0,92,0,99,0,0,0,75,0,107,0,247,0,198,0,179,0,204,0,135,0,128,0,0,0,24,0,172,0,102,0,114,0,74,0,0,0,19,0,90,0,0,0,26,0,218,0,51,0,160,0,106,0,242,0,180,0,42,0,255,0,8,0,205,0,94,0,127,0,30,0,115,0,52,0,10,0,0,0,162,0,175,0,110,0,250,0,97,0,29,0,131,0,0,0,0,0,182,0,17,0,166,0,0,0,0,0,23,0,120,0,214,0,60,0,204,0,251,0,150,0,38,0,174,0,88,0,155,0,120,0,104,0,141,0,0,0,0,0,118,0,134,0,149,0,224,0,0,0,232,0,145,0,166,0,0,0,27,0,65,0,0,0,29,0,177,0,99,0);
signal scenario_full  : scenario_type := (0,0,64,31,73,31,245,31,245,30,80,31,80,30,162,31,45,31,131,31,68,31,104,31,90,31,90,30,94,31,204,31,194,31,8,31,120,31,195,31,65,31,234,31,234,30,234,29,142,31,142,30,30,31,6,31,89,31,52,31,3,31,3,30,3,29,153,31,16,31,12,31,131,31,173,31,130,31,236,31,130,31,173,31,189,31,53,31,151,31,187,31,97,31,97,30,180,31,191,31,136,31,253,31,79,31,140,31,121,31,121,30,121,29,70,31,125,31,208,31,224,31,96,31,81,31,72,31,22,31,6,31,164,31,237,31,31,31,181,31,224,31,94,31,142,31,85,31,191,31,79,31,110,31,110,30,238,31,238,30,238,29,86,31,86,30,84,31,110,31,15,31,172,31,255,31,125,31,91,31,49,31,24,31,39,31,101,31,21,31,214,31,206,31,123,31,173,31,173,30,61,31,128,31,243,31,55,31,239,31,239,30,73,31,152,31,152,30,163,31,247,31,106,31,133,31,142,31,125,31,8,31,249,31,218,31,75,31,23,31,218,31,218,30,68,31,196,31,102,31,102,30,24,31,24,30,155,31,226,31,23,31,15,31,204,31,238,31,30,31,30,30,243,31,84,31,231,31,174,31,195,31,90,31,212,31,212,30,217,31,217,30,221,31,222,31,90,31,85,31,85,30,207,31,18,31,233,31,233,30,42,31,4,31,4,30,219,31,130,31,186,31,162,31,162,30,97,31,84,31,131,31,81,31,81,30,81,29,9,31,9,30,7,31,7,30,197,31,96,31,175,31,175,30,43,31,185,31,48,31,191,31,17,31,211,31,199,31,199,30,194,31,194,30,194,29,47,31,47,30,47,29,166,31,133,31,90,31,25,31,135,31,165,31,125,31,245,31,193,31,193,30,134,31,183,31,137,31,149,31,149,30,87,31,74,31,135,31,135,30,108,31,190,31,151,31,237,31,199,31,181,31,89,31,176,31,176,30,248,31,19,31,73,31,175,31,175,30,219,31,156,31,246,31,246,30,246,29,77,31,198,31,215,31,159,31,159,30,33,31,33,30,186,31,163,31,3,31,26,31,26,30,211,31,7,31,113,31,181,31,208,31,131,31,65,31,185,31,95,31,102,31,241,31,76,31,76,30,131,31,47,31,99,31,194,31,108,31,108,30,18,31,238,31,162,31,162,30,162,29,27,31,4,31,167,31,24,31,47,31,193,31,181,31,130,31,102,31,42,31,73,31,244,31,245,31,245,30,221,31,221,30,221,29,102,31,155,31,155,30,219,31,11,31,40,31,184,31,21,31,108,31,108,30,129,31,186,31,208,31,140,31,16,31,170,31,179,31,138,31,230,31,230,30,14,31,255,31,165,31,101,31,159,31,89,31,241,31,5,31,90,31,90,30,22,31,22,30,37,31,37,31,144,31,30,31,252,31,156,31,183,31,143,31,143,30,143,29,118,31,252,31,252,30,114,31,75,31,174,31,72,31,157,31,167,31,40,31,40,30,40,29,225,31,225,30,225,29,144,31,252,31,242,31,17,31,17,30,250,31,250,30,120,31,2,31,182,31,201,31,74,31,158,31,158,30,158,29,81,31,149,31,149,30,14,31,22,31,41,31,41,30,173,31,122,31,232,31,232,30,32,31,32,30,141,31,186,31,187,31,76,31,220,31,32,31,52,31,52,30,52,29,245,31,162,31,107,31,244,31,13,31,103,31,45,31,45,30,129,31,203,31,203,30,65,31,10,31,18,31,251,31,187,31,60,31,130,31,127,31,149,31,149,30,150,31,161,31,140,31,57,31,248,31,107,31,215,31,250,31,59,31,59,30,198,31,18,31,238,31,209,31,91,31,101,31,48,31,50,31,50,30,218,31,231,31,42,31,164,31,104,31,200,31,200,30,200,29,160,31,26,31,208,31,6,31,119,31,90,31,39,31,39,30,135,31,58,31,152,31,194,31,84,31,109,31,183,31,171,31,171,30,171,29,157,31,163,31,163,30,163,29,90,31,239,31,239,30,121,31,250,31,213,31,213,30,231,31,67,31,67,30,67,29,45,31,110,31,228,31,12,31,66,31,81,31,62,31,123,31,123,30,102,31,81,31,143,31,140,31,164,31,205,31,205,30,1,31,86,31,102,31,102,30,102,29,133,31,133,30,151,31,166,31,40,31,19,31,152,31,152,30,152,29,79,31,79,30,83,31,83,30,83,29,108,31,161,31,68,31,81,31,97,31,68,31,78,31,210,31,221,31,71,31,15,31,173,31,87,31,103,31,15,31,15,30,196,31,196,30,227,31,227,30,151,31,72,31,141,31,135,31,29,31,114,31,77,31,142,31,229,31,123,31,116,31,116,30,203,31,200,31,63,31,45,31,17,31,146,31,82,31,82,30,92,31,99,31,99,30,75,31,107,31,247,31,198,31,179,31,204,31,135,31,128,31,128,30,24,31,172,31,102,31,114,31,74,31,74,30,19,31,90,31,90,30,26,31,218,31,51,31,160,31,106,31,242,31,180,31,42,31,255,31,8,31,205,31,94,31,127,31,30,31,115,31,52,31,10,31,10,30,162,31,175,31,110,31,250,31,97,31,29,31,131,31,131,30,131,29,182,31,17,31,166,31,166,30,166,29,23,31,120,31,214,31,60,31,204,31,251,31,150,31,38,31,174,31,88,31,155,31,120,31,104,31,141,31,141,30,141,29,118,31,134,31,149,31,224,31,224,30,232,31,145,31,166,31,166,30,27,31,65,31,65,30,29,31,177,31,99,31);

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
