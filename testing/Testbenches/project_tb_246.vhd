-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_246 is
end project_tb_246;

architecture project_tb_arch_246 of project_tb_246 is
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

constant SCENARIO_LENGTH : integer := 607;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (45,0,222,0,142,0,94,0,0,0,135,0,40,0,197,0,30,0,5,0,49,0,81,0,124,0,55,0,130,0,128,0,97,0,216,0,246,0,30,0,0,0,0,0,112,0,0,0,66,0,170,0,220,0,165,0,57,0,0,0,0,0,0,0,42,0,0,0,4,0,120,0,239,0,53,0,72,0,63,0,192,0,0,0,143,0,213,0,0,0,166,0,186,0,85,0,131,0,0,0,0,0,176,0,60,0,17,0,0,0,132,0,147,0,214,0,202,0,143,0,12,0,0,0,138,0,97,0,24,0,80,0,0,0,97,0,186,0,0,0,99,0,23,0,0,0,121,0,139,0,166,0,140,0,229,0,184,0,108,0,231,0,59,0,0,0,1,0,127,0,142,0,0,0,190,0,0,0,81,0,7,0,17,0,154,0,222,0,166,0,0,0,197,0,202,0,147,0,168,0,233,0,0,0,0,0,78,0,135,0,99,0,0,0,101,0,92,0,0,0,199,0,174,0,232,0,219,0,240,0,74,0,123,0,168,0,8,0,41,0,0,0,119,0,0,0,122,0,160,0,104,0,0,0,69,0,0,0,210,0,206,0,77,0,98,0,126,0,88,0,140,0,137,0,129,0,224,0,198,0,79,0,225,0,133,0,25,0,0,0,110,0,85,0,0,0,19,0,90,0,225,0,108,0,0,0,94,0,0,0,49,0,0,0,133,0,118,0,0,0,106,0,203,0,58,0,187,0,159,0,89,0,214,0,230,0,175,0,0,0,0,0,102,0,205,0,94,0,0,0,234,0,166,0,0,0,142,0,253,0,232,0,28,0,0,0,230,0,73,0,237,0,1,0,243,0,96,0,0,0,2,0,60,0,81,0,209,0,71,0,92,0,197,0,183,0,171,0,117,0,23,0,0,0,16,0,188,0,89,0,232,0,146,0,36,0,194,0,120,0,44,0,222,0,0,0,164,0,194,0,187,0,0,0,69,0,0,0,0,0,164,0,97,0,0,0,0,0,0,0,14,0,108,0,168,0,48,0,8,0,90,0,160,0,241,0,11,0,56,0,52,0,52,0,110,0,168,0,0,0,191,0,6,0,220,0,0,0,50,0,33,0,248,0,124,0,216,0,0,0,0,0,85,0,66,0,240,0,34,0,0,0,200,0,206,0,0,0,240,0,161,0,153,0,51,0,200,0,0,0,46,0,73,0,8,0,115,0,188,0,223,0,97,0,149,0,159,0,0,0,51,0,73,0,42,0,183,0,0,0,197,0,85,0,0,0,31,0,0,0,118,0,161,0,34,0,68,0,125,0,79,0,0,0,0,0,225,0,17,0,90,0,232,0,56,0,1,0,4,0,0,0,0,0,6,0,81,0,172,0,66,0,24,0,210,0,165,0,211,0,111,0,237,0,126,0,0,0,202,0,31,0,237,0,241,0,95,0,131,0,140,0,187,0,191,0,47,0,5,0,122,0,17,0,34,0,176,0,112,0,124,0,75,0,204,0,105,0,10,0,0,0,240,0,98,0,67,0,79,0,108,0,0,0,0,0,0,0,40,0,22,0,180,0,0,0,255,0,1,0,151,0,0,0,206,0,194,0,142,0,190,0,178,0,13,0,41,0,34,0,255,0,174,0,191,0,213,0,0,0,161,0,74,0,65,0,109,0,204,0,237,0,16,0,40,0,109,0,184,0,84,0,0,0,72,0,0,0,125,0,158,0,224,0,243,0,244,0,108,0,235,0,210,0,0,0,233,0,2,0,131,0,94,0,0,0,185,0,187,0,124,0,122,0,44,0,0,0,123,0,253,0,0,0,252,0,39,0,0,0,0,0,72,0,153,0,200,0,133,0,121,0,21,0,85,0,56,0,38,0,100,0,0,0,121,0,109,0,135,0,33,0,223,0,153,0,136,0,56,0,38,0,58,0,157,0,0,0,155,0,0,0,208,0,70,0,0,0,0,0,203,0,98,0,203,0,73,0,0,0,0,0,96,0,92,0,79,0,0,0,163,0,125,0,207,0,114,0,0,0,27,0,209,0,10,0,195,0,161,0,172,0,0,0,53,0,72,0,165,0,219,0,114,0,89,0,0,0,130,0,96,0,238,0,72,0,20,0,103,0,91,0,2,0,219,0,125,0,250,0,156,0,0,0,118,0,181,0,156,0,107,0,245,0,8,0,90,0,37,0,0,0,250,0,0,0,41,0,151,0,8,0,0,0,243,0,222,0,208,0,0,0,1,0,159,0,213,0,136,0,0,0,118,0,246,0,144,0,118,0,254,0,224,0,189,0,107,0,171,0,19,0,187,0,131,0,93,0,37,0,26,0,76,0,116,0,53,0,139,0,150,0,209,0,31,0,50,0,150,0,86,0,56,0,129,0,171,0,206,0,62,0,68,0,21,0,227,0,30,0,219,0,211,0,0,0,118,0,158,0,146,0,79,0,70,0,197,0,200,0,39,0,72,0,154,0,163,0,0,0,101,0,0,0,186,0,134,0,241,0,5,0,0,0,29,0,177,0,234,0,186,0,213,0,124,0,168,0,124,0,165,0,22,0,0,0,155,0,0,0,14,0,193,0,76,0,199,0,152,0,169,0,252,0,153,0,173,0,71,0,207,0,122,0,115,0,120,0,205,0,0,0,13,0,0,0,225,0,171,0,121,0,204,0,51,0,76,0,0,0,25,0,255,0,155,0,77,0,100,0,64,0,245,0,0,0,199,0,183,0,63,0,102,0);
signal scenario_full  : scenario_type := (45,31,222,31,142,31,94,31,94,30,135,31,40,31,197,31,30,31,5,31,49,31,81,31,124,31,55,31,130,31,128,31,97,31,216,31,246,31,30,31,30,30,30,29,112,31,112,30,66,31,170,31,220,31,165,31,57,31,57,30,57,29,57,28,42,31,42,30,4,31,120,31,239,31,53,31,72,31,63,31,192,31,192,30,143,31,213,31,213,30,166,31,186,31,85,31,131,31,131,30,131,29,176,31,60,31,17,31,17,30,132,31,147,31,214,31,202,31,143,31,12,31,12,30,138,31,97,31,24,31,80,31,80,30,97,31,186,31,186,30,99,31,23,31,23,30,121,31,139,31,166,31,140,31,229,31,184,31,108,31,231,31,59,31,59,30,1,31,127,31,142,31,142,30,190,31,190,30,81,31,7,31,17,31,154,31,222,31,166,31,166,30,197,31,202,31,147,31,168,31,233,31,233,30,233,29,78,31,135,31,99,31,99,30,101,31,92,31,92,30,199,31,174,31,232,31,219,31,240,31,74,31,123,31,168,31,8,31,41,31,41,30,119,31,119,30,122,31,160,31,104,31,104,30,69,31,69,30,210,31,206,31,77,31,98,31,126,31,88,31,140,31,137,31,129,31,224,31,198,31,79,31,225,31,133,31,25,31,25,30,110,31,85,31,85,30,19,31,90,31,225,31,108,31,108,30,94,31,94,30,49,31,49,30,133,31,118,31,118,30,106,31,203,31,58,31,187,31,159,31,89,31,214,31,230,31,175,31,175,30,175,29,102,31,205,31,94,31,94,30,234,31,166,31,166,30,142,31,253,31,232,31,28,31,28,30,230,31,73,31,237,31,1,31,243,31,96,31,96,30,2,31,60,31,81,31,209,31,71,31,92,31,197,31,183,31,171,31,117,31,23,31,23,30,16,31,188,31,89,31,232,31,146,31,36,31,194,31,120,31,44,31,222,31,222,30,164,31,194,31,187,31,187,30,69,31,69,30,69,29,164,31,97,31,97,30,97,29,97,28,14,31,108,31,168,31,48,31,8,31,90,31,160,31,241,31,11,31,56,31,52,31,52,31,110,31,168,31,168,30,191,31,6,31,220,31,220,30,50,31,33,31,248,31,124,31,216,31,216,30,216,29,85,31,66,31,240,31,34,31,34,30,200,31,206,31,206,30,240,31,161,31,153,31,51,31,200,31,200,30,46,31,73,31,8,31,115,31,188,31,223,31,97,31,149,31,159,31,159,30,51,31,73,31,42,31,183,31,183,30,197,31,85,31,85,30,31,31,31,30,118,31,161,31,34,31,68,31,125,31,79,31,79,30,79,29,225,31,17,31,90,31,232,31,56,31,1,31,4,31,4,30,4,29,6,31,81,31,172,31,66,31,24,31,210,31,165,31,211,31,111,31,237,31,126,31,126,30,202,31,31,31,237,31,241,31,95,31,131,31,140,31,187,31,191,31,47,31,5,31,122,31,17,31,34,31,176,31,112,31,124,31,75,31,204,31,105,31,10,31,10,30,240,31,98,31,67,31,79,31,108,31,108,30,108,29,108,28,40,31,22,31,180,31,180,30,255,31,1,31,151,31,151,30,206,31,194,31,142,31,190,31,178,31,13,31,41,31,34,31,255,31,174,31,191,31,213,31,213,30,161,31,74,31,65,31,109,31,204,31,237,31,16,31,40,31,109,31,184,31,84,31,84,30,72,31,72,30,125,31,158,31,224,31,243,31,244,31,108,31,235,31,210,31,210,30,233,31,2,31,131,31,94,31,94,30,185,31,187,31,124,31,122,31,44,31,44,30,123,31,253,31,253,30,252,31,39,31,39,30,39,29,72,31,153,31,200,31,133,31,121,31,21,31,85,31,56,31,38,31,100,31,100,30,121,31,109,31,135,31,33,31,223,31,153,31,136,31,56,31,38,31,58,31,157,31,157,30,155,31,155,30,208,31,70,31,70,30,70,29,203,31,98,31,203,31,73,31,73,30,73,29,96,31,92,31,79,31,79,30,163,31,125,31,207,31,114,31,114,30,27,31,209,31,10,31,195,31,161,31,172,31,172,30,53,31,72,31,165,31,219,31,114,31,89,31,89,30,130,31,96,31,238,31,72,31,20,31,103,31,91,31,2,31,219,31,125,31,250,31,156,31,156,30,118,31,181,31,156,31,107,31,245,31,8,31,90,31,37,31,37,30,250,31,250,30,41,31,151,31,8,31,8,30,243,31,222,31,208,31,208,30,1,31,159,31,213,31,136,31,136,30,118,31,246,31,144,31,118,31,254,31,224,31,189,31,107,31,171,31,19,31,187,31,131,31,93,31,37,31,26,31,76,31,116,31,53,31,139,31,150,31,209,31,31,31,50,31,150,31,86,31,56,31,129,31,171,31,206,31,62,31,68,31,21,31,227,31,30,31,219,31,211,31,211,30,118,31,158,31,146,31,79,31,70,31,197,31,200,31,39,31,72,31,154,31,163,31,163,30,101,31,101,30,186,31,134,31,241,31,5,31,5,30,29,31,177,31,234,31,186,31,213,31,124,31,168,31,124,31,165,31,22,31,22,30,155,31,155,30,14,31,193,31,76,31,199,31,152,31,169,31,252,31,153,31,173,31,71,31,207,31,122,31,115,31,120,31,205,31,205,30,13,31,13,30,225,31,171,31,121,31,204,31,51,31,76,31,76,30,25,31,255,31,155,31,77,31,100,31,64,31,245,31,245,30,199,31,183,31,63,31,102,31);

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
