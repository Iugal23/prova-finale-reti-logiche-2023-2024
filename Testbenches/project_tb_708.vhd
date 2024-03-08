-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_708 is
end project_tb_708;

architecture project_tb_arch_708 of project_tb_708 is
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

constant SCENARIO_LENGTH : integer := 547;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (181,0,0,0,0,0,69,0,96,0,180,0,144,0,1,0,234,0,168,0,187,0,241,0,23,0,143,0,75,0,0,0,47,0,185,0,145,0,0,0,148,0,119,0,0,0,81,0,0,0,115,0,163,0,21,0,156,0,168,0,0,0,0,0,151,0,218,0,0,0,4,0,0,0,0,0,71,0,81,0,144,0,0,0,192,0,162,0,63,0,116,0,123,0,0,0,222,0,19,0,96,0,233,0,0,0,222,0,49,0,56,0,39,0,205,0,0,0,107,0,0,0,0,0,197,0,145,0,0,0,184,0,233,0,1,0,234,0,0,0,90,0,170,0,249,0,99,0,59,0,110,0,0,0,30,0,193,0,85,0,0,0,0,0,190,0,27,0,215,0,159,0,173,0,0,0,222,0,224,0,94,0,0,0,139,0,110,0,0,0,204,0,0,0,91,0,75,0,141,0,170,0,73,0,0,0,0,0,0,0,0,0,0,0,0,0,171,0,0,0,108,0,192,0,248,0,65,0,0,0,0,0,123,0,26,0,0,0,61,0,253,0,5,0,240,0,0,0,153,0,69,0,0,0,241,0,52,0,226,0,251,0,225,0,81,0,119,0,0,0,79,0,203,0,0,0,72,0,38,0,86,0,0,0,0,0,0,0,0,0,236,0,157,0,97,0,89,0,61,0,122,0,4,0,224,0,140,0,0,0,178,0,0,0,190,0,248,0,146,0,0,0,0,0,157,0,246,0,152,0,177,0,0,0,108,0,0,0,209,0,231,0,225,0,231,0,183,0,160,0,31,0,0,0,0,0,86,0,141,0,107,0,138,0,194,0,0,0,173,0,169,0,225,0,139,0,194,0,20,0,107,0,0,0,101,0,148,0,217,0,79,0,0,0,33,0,178,0,0,0,146,0,30,0,41,0,16,0,0,0,109,0,0,0,0,0,68,0,0,0,105,0,110,0,163,0,10,0,194,0,0,0,43,0,218,0,0,0,124,0,0,0,185,0,0,0,156,0,156,0,253,0,212,0,16,0,0,0,169,0,0,0,162,0,81,0,191,0,155,0,18,0,101,0,31,0,166,0,175,0,117,0,191,0,128,0,37,0,214,0,0,0,123,0,144,0,155,0,223,0,76,0,183,0,154,0,212,0,190,0,198,0,0,0,0,0,109,0,106,0,0,0,117,0,0,0,228,0,199,0,104,0,0,0,49,0,184,0,3,0,204,0,100,0,0,0,0,0,0,0,0,0,0,0,48,0,77,0,44,0,125,0,184,0,247,0,182,0,197,0,224,0,15,0,118,0,150,0,72,0,204,0,0,0,65,0,0,0,121,0,102,0,112,0,98,0,114,0,55,0,124,0,84,0,80,0,164,0,58,0,63,0,30,0,124,0,0,0,149,0,31,0,68,0,0,0,17,0,104,0,239,0,54,0,155,0,123,0,213,0,0,0,164,0,0,0,72,0,0,0,0,0,197,0,0,0,103,0,204,0,0,0,117,0,0,0,13,0,138,0,104,0,251,0,40,0,223,0,0,0,247,0,76,0,2,0,159,0,184,0,0,0,90,0,15,0,0,0,71,0,174,0,218,0,4,0,204,0,197,0,80,0,0,0,188,0,0,0,171,0,137,0,151,0,129,0,0,0,0,0,23,0,3,0,192,0,0,0,114,0,108,0,153,0,117,0,193,0,64,0,158,0,96,0,65,0,253,0,158,0,204,0,117,0,237,0,8,0,57,0,52,0,0,0,0,0,131,0,0,0,198,0,39,0,17,0,127,0,29,0,209,0,163,0,132,0,230,0,243,0,246,0,124,0,247,0,0,0,29,0,226,0,0,0,213,0,185,0,252,0,172,0,123,0,99,0,21,0,179,0,200,0,77,0,206,0,20,0,0,0,173,0,144,0,172,0,0,0,98,0,148,0,249,0,172,0,106,0,91,0,62,0,239,0,229,0,194,0,211,0,213,0,217,0,247,0,189,0,0,0,44,0,44,0,210,0,122,0,243,0,104,0,196,0,80,0,242,0,0,0,71,0,0,0,122,0,127,0,144,0,0,0,224,0,78,0,126,0,62,0,130,0,252,0,0,0,245,0,8,0,0,0,169,0,247,0,2,0,165,0,136,0,51,0,0,0,15,0,205,0,114,0,0,0,146,0,28,0,0,0,197,0,224,0,0,0,108,0,174,0,20,0,122,0,0,0,200,0,151,0,0,0,136,0,126,0,138,0,46,0,19,0,0,0,27,0,110,0,239,0,180,0,200,0,73,0,96,0,219,0,208,0,215,0,83,0,66,0,0,0,0,0,67,0,126,0,9,0,98,0,48,0,138,0,200,0,107,0,124,0,109,0,27,0,14,0,0,0,0,0,0,0,187,0,140,0,226,0,147,0,98,0,188,0,0,0,234,0,237,0,0,0,28,0,142,0,210,0,167,0,174,0,0,0,181,0,205,0,0,0,0,0,102,0);
signal scenario_full  : scenario_type := (181,31,181,30,181,29,69,31,96,31,180,31,144,31,1,31,234,31,168,31,187,31,241,31,23,31,143,31,75,31,75,30,47,31,185,31,145,31,145,30,148,31,119,31,119,30,81,31,81,30,115,31,163,31,21,31,156,31,168,31,168,30,168,29,151,31,218,31,218,30,4,31,4,30,4,29,71,31,81,31,144,31,144,30,192,31,162,31,63,31,116,31,123,31,123,30,222,31,19,31,96,31,233,31,233,30,222,31,49,31,56,31,39,31,205,31,205,30,107,31,107,30,107,29,197,31,145,31,145,30,184,31,233,31,1,31,234,31,234,30,90,31,170,31,249,31,99,31,59,31,110,31,110,30,30,31,193,31,85,31,85,30,85,29,190,31,27,31,215,31,159,31,173,31,173,30,222,31,224,31,94,31,94,30,139,31,110,31,110,30,204,31,204,30,91,31,75,31,141,31,170,31,73,31,73,30,73,29,73,28,73,27,73,26,73,25,171,31,171,30,108,31,192,31,248,31,65,31,65,30,65,29,123,31,26,31,26,30,61,31,253,31,5,31,240,31,240,30,153,31,69,31,69,30,241,31,52,31,226,31,251,31,225,31,81,31,119,31,119,30,79,31,203,31,203,30,72,31,38,31,86,31,86,30,86,29,86,28,86,27,236,31,157,31,97,31,89,31,61,31,122,31,4,31,224,31,140,31,140,30,178,31,178,30,190,31,248,31,146,31,146,30,146,29,157,31,246,31,152,31,177,31,177,30,108,31,108,30,209,31,231,31,225,31,231,31,183,31,160,31,31,31,31,30,31,29,86,31,141,31,107,31,138,31,194,31,194,30,173,31,169,31,225,31,139,31,194,31,20,31,107,31,107,30,101,31,148,31,217,31,79,31,79,30,33,31,178,31,178,30,146,31,30,31,41,31,16,31,16,30,109,31,109,30,109,29,68,31,68,30,105,31,110,31,163,31,10,31,194,31,194,30,43,31,218,31,218,30,124,31,124,30,185,31,185,30,156,31,156,31,253,31,212,31,16,31,16,30,169,31,169,30,162,31,81,31,191,31,155,31,18,31,101,31,31,31,166,31,175,31,117,31,191,31,128,31,37,31,214,31,214,30,123,31,144,31,155,31,223,31,76,31,183,31,154,31,212,31,190,31,198,31,198,30,198,29,109,31,106,31,106,30,117,31,117,30,228,31,199,31,104,31,104,30,49,31,184,31,3,31,204,31,100,31,100,30,100,29,100,28,100,27,100,26,48,31,77,31,44,31,125,31,184,31,247,31,182,31,197,31,224,31,15,31,118,31,150,31,72,31,204,31,204,30,65,31,65,30,121,31,102,31,112,31,98,31,114,31,55,31,124,31,84,31,80,31,164,31,58,31,63,31,30,31,124,31,124,30,149,31,31,31,68,31,68,30,17,31,104,31,239,31,54,31,155,31,123,31,213,31,213,30,164,31,164,30,72,31,72,30,72,29,197,31,197,30,103,31,204,31,204,30,117,31,117,30,13,31,138,31,104,31,251,31,40,31,223,31,223,30,247,31,76,31,2,31,159,31,184,31,184,30,90,31,15,31,15,30,71,31,174,31,218,31,4,31,204,31,197,31,80,31,80,30,188,31,188,30,171,31,137,31,151,31,129,31,129,30,129,29,23,31,3,31,192,31,192,30,114,31,108,31,153,31,117,31,193,31,64,31,158,31,96,31,65,31,253,31,158,31,204,31,117,31,237,31,8,31,57,31,52,31,52,30,52,29,131,31,131,30,198,31,39,31,17,31,127,31,29,31,209,31,163,31,132,31,230,31,243,31,246,31,124,31,247,31,247,30,29,31,226,31,226,30,213,31,185,31,252,31,172,31,123,31,99,31,21,31,179,31,200,31,77,31,206,31,20,31,20,30,173,31,144,31,172,31,172,30,98,31,148,31,249,31,172,31,106,31,91,31,62,31,239,31,229,31,194,31,211,31,213,31,217,31,247,31,189,31,189,30,44,31,44,31,210,31,122,31,243,31,104,31,196,31,80,31,242,31,242,30,71,31,71,30,122,31,127,31,144,31,144,30,224,31,78,31,126,31,62,31,130,31,252,31,252,30,245,31,8,31,8,30,169,31,247,31,2,31,165,31,136,31,51,31,51,30,15,31,205,31,114,31,114,30,146,31,28,31,28,30,197,31,224,31,224,30,108,31,174,31,20,31,122,31,122,30,200,31,151,31,151,30,136,31,126,31,138,31,46,31,19,31,19,30,27,31,110,31,239,31,180,31,200,31,73,31,96,31,219,31,208,31,215,31,83,31,66,31,66,30,66,29,67,31,126,31,9,31,98,31,48,31,138,31,200,31,107,31,124,31,109,31,27,31,14,31,14,30,14,29,14,28,187,31,140,31,226,31,147,31,98,31,188,31,188,30,234,31,237,31,237,30,28,31,142,31,210,31,167,31,174,31,174,30,181,31,205,31,205,30,205,29,102,31);

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
