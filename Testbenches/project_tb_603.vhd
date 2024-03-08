-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_603 is
end project_tb_603;

architecture project_tb_arch_603 of project_tb_603 is
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

constant SCENARIO_LENGTH : integer := 414;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (151,0,234,0,0,0,0,0,213,0,85,0,118,0,78,0,252,0,135,0,80,0,0,0,12,0,103,0,204,0,178,0,77,0,161,0,204,0,196,0,116,0,0,0,27,0,203,0,84,0,0,0,71,0,112,0,183,0,56,0,163,0,198,0,62,0,25,0,100,0,178,0,107,0,78,0,84,0,201,0,13,0,87,0,33,0,166,0,167,0,100,0,5,0,182,0,126,0,0,0,70,0,48,0,50,0,51,0,82,0,85,0,62,0,47,0,43,0,246,0,203,0,136,0,167,0,140,0,34,0,95,0,187,0,175,0,133,0,103,0,85,0,0,0,54,0,64,0,1,0,0,0,222,0,125,0,0,0,165,0,140,0,213,0,0,0,169,0,0,0,0,0,193,0,114,0,81,0,100,0,91,0,162,0,11,0,180,0,71,0,0,0,0,0,0,0,186,0,0,0,99,0,139,0,159,0,252,0,83,0,207,0,11,0,110,0,216,0,0,0,0,0,0,0,138,0,246,0,158,0,0,0,0,0,0,0,75,0,42,0,213,0,190,0,247,0,109,0,118,0,107,0,0,0,18,0,18,0,187,0,222,0,49,0,4,0,159,0,26,0,134,0,4,0,77,0,100,0,90,0,57,0,213,0,0,0,91,0,237,0,124,0,0,0,224,0,153,0,218,0,172,0,0,0,23,0,47,0,154,0,112,0,224,0,228,0,0,0,195,0,90,0,199,0,7,0,64,0,253,0,196,0,53,0,227,0,0,0,48,0,62,0,155,0,101,0,138,0,170,0,206,0,57,0,0,0,83,0,179,0,213,0,69,0,241,0,241,0,194,0,57,0,0,0,224,0,0,0,129,0,181,0,52,0,140,0,0,0,195,0,31,0,20,0,128,0,169,0,0,0,0,0,137,0,56,0,150,0,0,0,26,0,0,0,2,0,146,0,33,0,75,0,23,0,129,0,191,0,75,0,0,0,169,0,25,0,148,0,210,0,169,0,69,0,106,0,141,0,81,0,0,0,219,0,3,0,0,0,94,0,146,0,52,0,86,0,120,0,4,0,225,0,121,0,228,0,211,0,179,0,44,0,232,0,0,0,144,0,122,0,242,0,132,0,215,0,75,0,232,0,0,0,40,0,37,0,145,0,0,0,101,0,235,0,241,0,0,0,102,0,126,0,245,0,173,0,9,0,70,0,253,0,185,0,66,0,125,0,167,0,202,0,197,0,255,0,214,0,25,0,0,0,126,0,138,0,157,0,164,0,193,0,109,0,248,0,243,0,0,0,48,0,86,0,211,0,69,0,170,0,178,0,186,0,108,0,65,0,154,0,0,0,126,0,62,0,168,0,0,0,102,0,0,0,0,0,0,0,123,0,54,0,233,0,18,0,99,0,41,0,95,0,104,0,44,0,157,0,202,0,97,0,0,0,126,0,173,0,28,0,128,0,210,0,0,0,15,0,123,0,170,0,0,0,181,0,94,0,0,0,0,0,237,0,110,0,0,0,115,0,197,0,57,0,110,0,155,0,227,0,150,0,105,0,161,0,66,0,111,0,5,0,161,0,0,0,185,0,133,0,69,0,217,0,113,0,0,0,76,0,0,0,58,0,22,0,15,0,56,0,0,0,0,0,240,0,0,0,0,0,244,0,27,0,211,0,83,0,57,0,40,0,46,0,0,0,0,0,214,0,120,0,0,0,108,0,57,0,84,0,113,0,225,0,73,0,18,0,0,0,66,0,73,0,136,0,69,0,160,0,189,0,133,0,218,0,53,0,124,0,88,0,0,0,160,0,255,0,161,0,248,0,0,0,185,0,215,0,43,0,161,0,130,0,228,0,114,0,0,0,187,0,53,0,27,0,121,0);
signal scenario_full  : scenario_type := (151,31,234,31,234,30,234,29,213,31,85,31,118,31,78,31,252,31,135,31,80,31,80,30,12,31,103,31,204,31,178,31,77,31,161,31,204,31,196,31,116,31,116,30,27,31,203,31,84,31,84,30,71,31,112,31,183,31,56,31,163,31,198,31,62,31,25,31,100,31,178,31,107,31,78,31,84,31,201,31,13,31,87,31,33,31,166,31,167,31,100,31,5,31,182,31,126,31,126,30,70,31,48,31,50,31,51,31,82,31,85,31,62,31,47,31,43,31,246,31,203,31,136,31,167,31,140,31,34,31,95,31,187,31,175,31,133,31,103,31,85,31,85,30,54,31,64,31,1,31,1,30,222,31,125,31,125,30,165,31,140,31,213,31,213,30,169,31,169,30,169,29,193,31,114,31,81,31,100,31,91,31,162,31,11,31,180,31,71,31,71,30,71,29,71,28,186,31,186,30,99,31,139,31,159,31,252,31,83,31,207,31,11,31,110,31,216,31,216,30,216,29,216,28,138,31,246,31,158,31,158,30,158,29,158,28,75,31,42,31,213,31,190,31,247,31,109,31,118,31,107,31,107,30,18,31,18,31,187,31,222,31,49,31,4,31,159,31,26,31,134,31,4,31,77,31,100,31,90,31,57,31,213,31,213,30,91,31,237,31,124,31,124,30,224,31,153,31,218,31,172,31,172,30,23,31,47,31,154,31,112,31,224,31,228,31,228,30,195,31,90,31,199,31,7,31,64,31,253,31,196,31,53,31,227,31,227,30,48,31,62,31,155,31,101,31,138,31,170,31,206,31,57,31,57,30,83,31,179,31,213,31,69,31,241,31,241,31,194,31,57,31,57,30,224,31,224,30,129,31,181,31,52,31,140,31,140,30,195,31,31,31,20,31,128,31,169,31,169,30,169,29,137,31,56,31,150,31,150,30,26,31,26,30,2,31,146,31,33,31,75,31,23,31,129,31,191,31,75,31,75,30,169,31,25,31,148,31,210,31,169,31,69,31,106,31,141,31,81,31,81,30,219,31,3,31,3,30,94,31,146,31,52,31,86,31,120,31,4,31,225,31,121,31,228,31,211,31,179,31,44,31,232,31,232,30,144,31,122,31,242,31,132,31,215,31,75,31,232,31,232,30,40,31,37,31,145,31,145,30,101,31,235,31,241,31,241,30,102,31,126,31,245,31,173,31,9,31,70,31,253,31,185,31,66,31,125,31,167,31,202,31,197,31,255,31,214,31,25,31,25,30,126,31,138,31,157,31,164,31,193,31,109,31,248,31,243,31,243,30,48,31,86,31,211,31,69,31,170,31,178,31,186,31,108,31,65,31,154,31,154,30,126,31,62,31,168,31,168,30,102,31,102,30,102,29,102,28,123,31,54,31,233,31,18,31,99,31,41,31,95,31,104,31,44,31,157,31,202,31,97,31,97,30,126,31,173,31,28,31,128,31,210,31,210,30,15,31,123,31,170,31,170,30,181,31,94,31,94,30,94,29,237,31,110,31,110,30,115,31,197,31,57,31,110,31,155,31,227,31,150,31,105,31,161,31,66,31,111,31,5,31,161,31,161,30,185,31,133,31,69,31,217,31,113,31,113,30,76,31,76,30,58,31,22,31,15,31,56,31,56,30,56,29,240,31,240,30,240,29,244,31,27,31,211,31,83,31,57,31,40,31,46,31,46,30,46,29,214,31,120,31,120,30,108,31,57,31,84,31,113,31,225,31,73,31,18,31,18,30,66,31,73,31,136,31,69,31,160,31,189,31,133,31,218,31,53,31,124,31,88,31,88,30,160,31,255,31,161,31,248,31,248,30,185,31,215,31,43,31,161,31,130,31,228,31,114,31,114,30,187,31,53,31,27,31,121,31);

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
