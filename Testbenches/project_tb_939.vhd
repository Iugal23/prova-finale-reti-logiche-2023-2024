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

constant SCENARIO_LENGTH : integer := 392;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (202,0,212,0,168,0,176,0,103,0,27,0,126,0,96,0,227,0,187,0,244,0,84,0,7,0,182,0,196,0,158,0,0,0,93,0,30,0,203,0,29,0,89,0,233,0,54,0,96,0,227,0,91,0,0,0,23,0,36,0,0,0,0,0,190,0,136,0,170,0,58,0,111,0,0,0,61,0,240,0,215,0,88,0,27,0,51,0,181,0,222,0,129,0,45,0,0,0,126,0,66,0,52,0,48,0,92,0,143,0,0,0,228,0,0,0,196,0,90,0,146,0,170,0,131,0,179,0,234,0,16,0,6,0,69,0,49,0,0,0,76,0,80,0,51,0,37,0,0,0,233,0,64,0,124,0,0,0,138,0,149,0,72,0,21,0,125,0,251,0,28,0,0,0,121,0,201,0,165,0,198,0,79,0,0,0,0,0,236,0,106,0,80,0,0,0,188,0,51,0,216,0,42,0,105,0,98,0,149,0,185,0,34,0,242,0,0,0,209,0,247,0,141,0,83,0,136,0,54,0,0,0,237,0,57,0,235,0,0,0,203,0,242,0,83,0,193,0,245,0,3,0,50,0,64,0,0,0,118,0,96,0,90,0,0,0,0,0,172,0,0,0,65,0,0,0,0,0,196,0,219,0,194,0,218,0,0,0,17,0,250,0,55,0,236,0,159,0,174,0,0,0,0,0,157,0,9,0,142,0,118,0,122,0,46,0,228,0,88,0,28,0,67,0,205,0,0,0,60,0,69,0,125,0,145,0,107,0,31,0,247,0,0,0,130,0,0,0,128,0,108,0,222,0,95,0,83,0,158,0,123,0,21,0,20,0,73,0,133,0,173,0,37,0,0,0,38,0,35,0,88,0,198,0,0,0,170,0,124,0,170,0,92,0,247,0,0,0,14,0,0,0,152,0,29,0,103,0,67,0,229,0,73,0,108,0,224,0,102,0,107,0,215,0,0,0,133,0,175,0,59,0,118,0,113,0,140,0,0,0,0,0,138,0,0,0,0,0,0,0,217,0,139,0,0,0,0,0,144,0,134,0,0,0,0,0,229,0,197,0,250,0,55,0,222,0,8,0,147,0,0,0,0,0,15,0,51,0,130,0,4,0,123,0,0,0,0,0,36,0,0,0,151,0,217,0,6,0,199,0,80,0,26,0,70,0,74,0,212,0,178,0,10,0,242,0,43,0,165,0,137,0,65,0,227,0,243,0,237,0,0,0,251,0,0,0,69,0,0,0,63,0,106,0,180,0,119,0,143,0,232,0,253,0,64,0,0,0,0,0,36,0,0,0,0,0,159,0,44,0,138,0,0,0,25,0,25,0,250,0,180,0,175,0,167,0,66,0,0,0,0,0,0,0,138,0,177,0,90,0,125,0,25,0,246,0,0,0,224,0,0,0,0,0,29,0,0,0,19,0,100,0,15,0,0,0,228,0,31,0,121,0,27,0,0,0,0,0,119,0,201,0,116,0,133,0,162,0,36,0,177,0,0,0,177,0,158,0,152,0,191,0,108,0,20,0,28,0,59,0,0,0,207,0,55,0,172,0,103,0,0,0,190,0,159,0,221,0,58,0,132,0,190,0,92,0,228,0,37,0,15,0,59,0,165,0,35,0,186,0,253,0,156,0,84,0,88,0,198,0,178,0,194,0,193,0,63,0,253,0,111,0,75,0,144,0,0,0,65,0,217,0,208,0,128,0,79,0,17,0,88,0,195,0,67,0,122,0,181,0,0,0,24,0,0,0,0,0,233,0,171,0,222,0);
signal scenario_full  : scenario_type := (202,31,212,31,168,31,176,31,103,31,27,31,126,31,96,31,227,31,187,31,244,31,84,31,7,31,182,31,196,31,158,31,158,30,93,31,30,31,203,31,29,31,89,31,233,31,54,31,96,31,227,31,91,31,91,30,23,31,36,31,36,30,36,29,190,31,136,31,170,31,58,31,111,31,111,30,61,31,240,31,215,31,88,31,27,31,51,31,181,31,222,31,129,31,45,31,45,30,126,31,66,31,52,31,48,31,92,31,143,31,143,30,228,31,228,30,196,31,90,31,146,31,170,31,131,31,179,31,234,31,16,31,6,31,69,31,49,31,49,30,76,31,80,31,51,31,37,31,37,30,233,31,64,31,124,31,124,30,138,31,149,31,72,31,21,31,125,31,251,31,28,31,28,30,121,31,201,31,165,31,198,31,79,31,79,30,79,29,236,31,106,31,80,31,80,30,188,31,51,31,216,31,42,31,105,31,98,31,149,31,185,31,34,31,242,31,242,30,209,31,247,31,141,31,83,31,136,31,54,31,54,30,237,31,57,31,235,31,235,30,203,31,242,31,83,31,193,31,245,31,3,31,50,31,64,31,64,30,118,31,96,31,90,31,90,30,90,29,172,31,172,30,65,31,65,30,65,29,196,31,219,31,194,31,218,31,218,30,17,31,250,31,55,31,236,31,159,31,174,31,174,30,174,29,157,31,9,31,142,31,118,31,122,31,46,31,228,31,88,31,28,31,67,31,205,31,205,30,60,31,69,31,125,31,145,31,107,31,31,31,247,31,247,30,130,31,130,30,128,31,108,31,222,31,95,31,83,31,158,31,123,31,21,31,20,31,73,31,133,31,173,31,37,31,37,30,38,31,35,31,88,31,198,31,198,30,170,31,124,31,170,31,92,31,247,31,247,30,14,31,14,30,152,31,29,31,103,31,67,31,229,31,73,31,108,31,224,31,102,31,107,31,215,31,215,30,133,31,175,31,59,31,118,31,113,31,140,31,140,30,140,29,138,31,138,30,138,29,138,28,217,31,139,31,139,30,139,29,144,31,134,31,134,30,134,29,229,31,197,31,250,31,55,31,222,31,8,31,147,31,147,30,147,29,15,31,51,31,130,31,4,31,123,31,123,30,123,29,36,31,36,30,151,31,217,31,6,31,199,31,80,31,26,31,70,31,74,31,212,31,178,31,10,31,242,31,43,31,165,31,137,31,65,31,227,31,243,31,237,31,237,30,251,31,251,30,69,31,69,30,63,31,106,31,180,31,119,31,143,31,232,31,253,31,64,31,64,30,64,29,36,31,36,30,36,29,159,31,44,31,138,31,138,30,25,31,25,31,250,31,180,31,175,31,167,31,66,31,66,30,66,29,66,28,138,31,177,31,90,31,125,31,25,31,246,31,246,30,224,31,224,30,224,29,29,31,29,30,19,31,100,31,15,31,15,30,228,31,31,31,121,31,27,31,27,30,27,29,119,31,201,31,116,31,133,31,162,31,36,31,177,31,177,30,177,31,158,31,152,31,191,31,108,31,20,31,28,31,59,31,59,30,207,31,55,31,172,31,103,31,103,30,190,31,159,31,221,31,58,31,132,31,190,31,92,31,228,31,37,31,15,31,59,31,165,31,35,31,186,31,253,31,156,31,84,31,88,31,198,31,178,31,194,31,193,31,63,31,253,31,111,31,75,31,144,31,144,30,65,31,217,31,208,31,128,31,79,31,17,31,88,31,195,31,67,31,122,31,181,31,181,30,24,31,24,30,24,29,233,31,171,31,222,31);

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
