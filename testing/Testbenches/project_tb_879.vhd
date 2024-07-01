-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_879 is
end project_tb_879;

architecture project_tb_arch_879 of project_tb_879 is
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

constant SCENARIO_LENGTH : integer := 513;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (126,0,136,0,50,0,182,0,203,0,209,0,133,0,25,0,137,0,45,0,116,0,0,0,222,0,84,0,222,0,103,0,186,0,99,0,165,0,223,0,0,0,103,0,205,0,53,0,173,0,166,0,138,0,0,0,109,0,172,0,0,0,28,0,140,0,125,0,169,0,0,0,23,0,0,0,0,0,0,0,117,0,248,0,231,0,73,0,15,0,18,0,120,0,43,0,99,0,99,0,246,0,172,0,0,0,50,0,117,0,37,0,157,0,4,0,220,0,0,0,234,0,105,0,132,0,108,0,27,0,0,0,41,0,0,0,119,0,0,0,111,0,213,0,0,0,0,0,168,0,220,0,153,0,0,0,114,0,29,0,133,0,72,0,192,0,0,0,0,0,0,0,243,0,0,0,218,0,146,0,0,0,57,0,79,0,0,0,243,0,79,0,248,0,56,0,110,0,49,0,0,0,8,0,43,0,172,0,22,0,221,0,129,0,182,0,130,0,0,0,62,0,241,0,71,0,24,0,204,0,163,0,64,0,151,0,0,0,180,0,234,0,21,0,54,0,212,0,216,0,24,0,1,0,0,0,25,0,0,0,0,0,57,0,0,0,197,0,0,0,34,0,49,0,193,0,92,0,159,0,170,0,0,0,0,0,0,0,8,0,181,0,0,0,190,0,218,0,228,0,25,0,176,0,195,0,65,0,110,0,0,0,11,0,141,0,9,0,170,0,196,0,0,0,64,0,0,0,79,0,19,0,170,0,145,0,0,0,0,0,0,0,0,0,0,0,130,0,19,0,230,0,8,0,160,0,12,0,0,0,0,0,231,0,0,0,119,0,112,0,0,0,25,0,112,0,215,0,73,0,191,0,86,0,248,0,233,0,117,0,190,0,42,0,135,0,40,0,0,0,185,0,130,0,212,0,85,0,2,0,201,0,0,0,0,0,234,0,91,0,0,0,189,0,17,0,190,0,187,0,7,0,0,0,182,0,0,0,54,0,0,0,0,0,19,0,139,0,0,0,235,0,0,0,60,0,50,0,94,0,0,0,0,0,69,0,207,0,156,0,110,0,199,0,242,0,0,0,0,0,88,0,252,0,192,0,48,0,247,0,30,0,226,0,143,0,95,0,210,0,91,0,0,0,0,0,167,0,166,0,177,0,0,0,0,0,71,0,156,0,193,0,7,0,156,0,39,0,16,0,87,0,122,0,70,0,104,0,197,0,242,0,130,0,47,0,24,0,178,0,215,0,150,0,0,0,244,0,135,0,221,0,0,0,134,0,0,0,0,0,0,0,0,0,122,0,2,0,110,0,5,0,0,0,195,0,0,0,0,0,0,0,85,0,0,0,0,0,137,0,224,0,190,0,0,0,0,0,248,0,51,0,0,0,240,0,193,0,89,0,143,0,203,0,246,0,27,0,147,0,255,0,0,0,184,0,120,0,0,0,112,0,67,0,197,0,0,0,156,0,192,0,169,0,146,0,112,0,60,0,39,0,35,0,215,0,0,0,127,0,200,0,72,0,92,0,0,0,0,0,87,0,0,0,22,0,220,0,4,0,54,0,0,0,166,0,86,0,77,0,233,0,33,0,60,0,0,0,0,0,223,0,80,0,250,0,69,0,98,0,123,0,244,0,178,0,153,0,0,0,94,0,242,0,0,0,181,0,201,0,42,0,176,0,126,0,105,0,95,0,179,0,29,0,216,0,0,0,235,0,238,0,198,0,192,0,212,0,209,0,7,0,120,0,166,0,136,0,51,0,179,0,163,0,101,0,244,0,63,0,227,0,252,0,222,0,83,0,5,0,229,0,7,0,202,0,0,0,17,0,0,0,215,0,84,0,8,0,181,0,207,0,189,0,5,0,24,0,162,0,27,0,103,0,111,0,21,0,250,0,44,0,70,0,170,0,171,0,138,0,44,0,232,0,190,0,155,0,187,0,114,0,253,0,227,0,254,0,42,0,134,0,220,0,225,0,34,0,15,0,0,0,74,0,0,0,178,0,79,0,143,0,25,0,238,0,0,0,253,0,242,0,68,0,0,0,70,0,57,0,0,0,0,0,83,0,147,0,62,0,22,0,0,0,58,0,0,0,168,0,215,0,58,0,21,0,52,0,233,0,166,0,0,0,63,0,0,0,98,0,214,0,10,0,157,0,218,0,0,0,101,0,0,0,55,0,0,0,0,0,135,0,73,0,49,0,181,0,49,0,243,0,182,0,66,0,120,0,231,0,119,0,191,0,9,0,172,0,188,0,125,0,0,0,125,0,175,0,71,0,0,0,177,0,245,0,108,0,71,0,62,0,250,0,84,0);
signal scenario_full  : scenario_type := (126,31,136,31,50,31,182,31,203,31,209,31,133,31,25,31,137,31,45,31,116,31,116,30,222,31,84,31,222,31,103,31,186,31,99,31,165,31,223,31,223,30,103,31,205,31,53,31,173,31,166,31,138,31,138,30,109,31,172,31,172,30,28,31,140,31,125,31,169,31,169,30,23,31,23,30,23,29,23,28,117,31,248,31,231,31,73,31,15,31,18,31,120,31,43,31,99,31,99,31,246,31,172,31,172,30,50,31,117,31,37,31,157,31,4,31,220,31,220,30,234,31,105,31,132,31,108,31,27,31,27,30,41,31,41,30,119,31,119,30,111,31,213,31,213,30,213,29,168,31,220,31,153,31,153,30,114,31,29,31,133,31,72,31,192,31,192,30,192,29,192,28,243,31,243,30,218,31,146,31,146,30,57,31,79,31,79,30,243,31,79,31,248,31,56,31,110,31,49,31,49,30,8,31,43,31,172,31,22,31,221,31,129,31,182,31,130,31,130,30,62,31,241,31,71,31,24,31,204,31,163,31,64,31,151,31,151,30,180,31,234,31,21,31,54,31,212,31,216,31,24,31,1,31,1,30,25,31,25,30,25,29,57,31,57,30,197,31,197,30,34,31,49,31,193,31,92,31,159,31,170,31,170,30,170,29,170,28,8,31,181,31,181,30,190,31,218,31,228,31,25,31,176,31,195,31,65,31,110,31,110,30,11,31,141,31,9,31,170,31,196,31,196,30,64,31,64,30,79,31,19,31,170,31,145,31,145,30,145,29,145,28,145,27,145,26,130,31,19,31,230,31,8,31,160,31,12,31,12,30,12,29,231,31,231,30,119,31,112,31,112,30,25,31,112,31,215,31,73,31,191,31,86,31,248,31,233,31,117,31,190,31,42,31,135,31,40,31,40,30,185,31,130,31,212,31,85,31,2,31,201,31,201,30,201,29,234,31,91,31,91,30,189,31,17,31,190,31,187,31,7,31,7,30,182,31,182,30,54,31,54,30,54,29,19,31,139,31,139,30,235,31,235,30,60,31,50,31,94,31,94,30,94,29,69,31,207,31,156,31,110,31,199,31,242,31,242,30,242,29,88,31,252,31,192,31,48,31,247,31,30,31,226,31,143,31,95,31,210,31,91,31,91,30,91,29,167,31,166,31,177,31,177,30,177,29,71,31,156,31,193,31,7,31,156,31,39,31,16,31,87,31,122,31,70,31,104,31,197,31,242,31,130,31,47,31,24,31,178,31,215,31,150,31,150,30,244,31,135,31,221,31,221,30,134,31,134,30,134,29,134,28,134,27,122,31,2,31,110,31,5,31,5,30,195,31,195,30,195,29,195,28,85,31,85,30,85,29,137,31,224,31,190,31,190,30,190,29,248,31,51,31,51,30,240,31,193,31,89,31,143,31,203,31,246,31,27,31,147,31,255,31,255,30,184,31,120,31,120,30,112,31,67,31,197,31,197,30,156,31,192,31,169,31,146,31,112,31,60,31,39,31,35,31,215,31,215,30,127,31,200,31,72,31,92,31,92,30,92,29,87,31,87,30,22,31,220,31,4,31,54,31,54,30,166,31,86,31,77,31,233,31,33,31,60,31,60,30,60,29,223,31,80,31,250,31,69,31,98,31,123,31,244,31,178,31,153,31,153,30,94,31,242,31,242,30,181,31,201,31,42,31,176,31,126,31,105,31,95,31,179,31,29,31,216,31,216,30,235,31,238,31,198,31,192,31,212,31,209,31,7,31,120,31,166,31,136,31,51,31,179,31,163,31,101,31,244,31,63,31,227,31,252,31,222,31,83,31,5,31,229,31,7,31,202,31,202,30,17,31,17,30,215,31,84,31,8,31,181,31,207,31,189,31,5,31,24,31,162,31,27,31,103,31,111,31,21,31,250,31,44,31,70,31,170,31,171,31,138,31,44,31,232,31,190,31,155,31,187,31,114,31,253,31,227,31,254,31,42,31,134,31,220,31,225,31,34,31,15,31,15,30,74,31,74,30,178,31,79,31,143,31,25,31,238,31,238,30,253,31,242,31,68,31,68,30,70,31,57,31,57,30,57,29,83,31,147,31,62,31,22,31,22,30,58,31,58,30,168,31,215,31,58,31,21,31,52,31,233,31,166,31,166,30,63,31,63,30,98,31,214,31,10,31,157,31,218,31,218,30,101,31,101,30,55,31,55,30,55,29,135,31,73,31,49,31,181,31,49,31,243,31,182,31,66,31,120,31,231,31,119,31,191,31,9,31,172,31,188,31,125,31,125,30,125,31,175,31,71,31,71,30,177,31,245,31,108,31,71,31,62,31,250,31,84,31);

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
