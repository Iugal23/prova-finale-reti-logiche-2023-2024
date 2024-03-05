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

signal scenario_input : scenario_type := (215,0,218,0,242,0,186,0,158,0,175,0,75,0,146,0,0,0,0,0,0,0,147,0,141,0,107,0,123,0,255,0,6,0,113,0,64,0,180,0,0,0,171,0,208,0,59,0,218,0,10,0,0,0,99,0,254,0,54,0,216,0,0,0,0,0,149,0,64,0,199,0,0,0,159,0,15,0,61,0,0,0,38,0,20,0,94,0,24,0,11,0,153,0,201,0,28,0,121,0,184,0,174,0,0,0,0,0,78,0,0,0,209,0,10,0,149,0,113,0,0,0,184,0,124,0,225,0,231,0,0,0,135,0,0,0,0,0,0,0,0,0,13,0,99,0,140,0,176,0,0,0,228,0,0,0,65,0,34,0,193,0,69,0,198,0,22,0,145,0,0,0,0,0,52,0,1,0,118,0,112,0,225,0,11,0,0,0,213,0,173,0,6,0,121,0,157,0,210,0,178,0,0,0,0,0,0,0,19,0,51,0,56,0,212,0,253,0,139,0,171,0,80,0,75,0,223,0,173,0,69,0,128,0,0,0,173,0,166,0,29,0,3,0,84,0,101,0,213,0,16,0,181,0,17,0,134,0,0,0,2,0,0,0,105,0,205,0,141,0,217,0,243,0,0,0,117,0,214,0,20,0,150,0,221,0,136,0,62,0,255,0,110,0,0,0,89,0,165,0,252,0,136,0,0,0,126,0,65,0,0,0,0,0,71,0,0,0,91,0,0,0,2,0,0,0,0,0,126,0,205,0,122,0,22,0,214,0,68,0,204,0,55,0,239,0,88,0,150,0,231,0,62,0,14,0,0,0,134,0,90,0,173,0,45,0,129,0,195,0,0,0,0,0,90,0,69,0,31,0,169,0,191,0,80,0,0,0,145,0,229,0,141,0,0,0,118,0,248,0,1,0,34,0,160,0,241,0,0,0,13,0,83,0,110,0,220,0,161,0,53,0,155,0,147,0,252,0,149,0,228,0,121,0,14,0,215,0,247,0,200,0,121,0,158,0,165,0,0,0,0,0,103,0,172,0,186,0,130,0,134,0,71,0,0,0,244,0,0,0,13,0,245,0,181,0,109,0,161,0,205,0,21,0,9,0,0,0,106,0,70,0,44,0,0,0,242,0,182,0,11,0,163,0,21,0,141,0,113,0,49,0,7,0,0,0,66,0,5,0,204,0,246,0,129,0,218,0,112,0,0,0,252,0,170,0,7,0,90,0,145,0,8,0,191,0,176,0,144,0,0,0,225,0,43,0,0,0,248,0,1,0,90,0,9,0,0,0,27,0,0,0,133,0,0,0,212,0,97,0,133,0,0,0,140,0,117,0,228,0,0,0,166,0,188,0,106,0,127,0,39,0,47,0,0,0,100,0,3,0,0,0,124,0,29,0,91,0,83,0,146,0,230,0,110,0,0,0,81,0,169,0,106,0,104,0,221,0,196,0,65,0,149,0,21,0,77,0,91,0,68,0,155,0,8,0,0,0,0,0,164,0,0,0,254,0,40,0,0,0,124,0,208,0,209,0,224,0,246,0,15,0,51,0,1,0,23,0,22,0,243,0,30,0,176,0,229,0,162,0,25,0,0,0,61,0,0,0,67,0,248,0,69,0,0,0,169,0,0,0,15,0,0,0,7,0,207,0,150,0,0,0,98,0,21,0,33,0,0,0,59,0,85,0,28,0,32,0,127,0,148,0,127,0,210,0,177,0,205,0,133,0,52,0,5,0,148,0,223,0,199,0,213,0,0,0,197,0,233,0,52,0,219,0);
signal scenario_full  : scenario_type := (215,31,218,31,242,31,186,31,158,31,175,31,75,31,146,31,146,30,146,29,146,28,147,31,141,31,107,31,123,31,255,31,6,31,113,31,64,31,180,31,180,30,171,31,208,31,59,31,218,31,10,31,10,30,99,31,254,31,54,31,216,31,216,30,216,29,149,31,64,31,199,31,199,30,159,31,15,31,61,31,61,30,38,31,20,31,94,31,24,31,11,31,153,31,201,31,28,31,121,31,184,31,174,31,174,30,174,29,78,31,78,30,209,31,10,31,149,31,113,31,113,30,184,31,124,31,225,31,231,31,231,30,135,31,135,30,135,29,135,28,135,27,13,31,99,31,140,31,176,31,176,30,228,31,228,30,65,31,34,31,193,31,69,31,198,31,22,31,145,31,145,30,145,29,52,31,1,31,118,31,112,31,225,31,11,31,11,30,213,31,173,31,6,31,121,31,157,31,210,31,178,31,178,30,178,29,178,28,19,31,51,31,56,31,212,31,253,31,139,31,171,31,80,31,75,31,223,31,173,31,69,31,128,31,128,30,173,31,166,31,29,31,3,31,84,31,101,31,213,31,16,31,181,31,17,31,134,31,134,30,2,31,2,30,105,31,205,31,141,31,217,31,243,31,243,30,117,31,214,31,20,31,150,31,221,31,136,31,62,31,255,31,110,31,110,30,89,31,165,31,252,31,136,31,136,30,126,31,65,31,65,30,65,29,71,31,71,30,91,31,91,30,2,31,2,30,2,29,126,31,205,31,122,31,22,31,214,31,68,31,204,31,55,31,239,31,88,31,150,31,231,31,62,31,14,31,14,30,134,31,90,31,173,31,45,31,129,31,195,31,195,30,195,29,90,31,69,31,31,31,169,31,191,31,80,31,80,30,145,31,229,31,141,31,141,30,118,31,248,31,1,31,34,31,160,31,241,31,241,30,13,31,83,31,110,31,220,31,161,31,53,31,155,31,147,31,252,31,149,31,228,31,121,31,14,31,215,31,247,31,200,31,121,31,158,31,165,31,165,30,165,29,103,31,172,31,186,31,130,31,134,31,71,31,71,30,244,31,244,30,13,31,245,31,181,31,109,31,161,31,205,31,21,31,9,31,9,30,106,31,70,31,44,31,44,30,242,31,182,31,11,31,163,31,21,31,141,31,113,31,49,31,7,31,7,30,66,31,5,31,204,31,246,31,129,31,218,31,112,31,112,30,252,31,170,31,7,31,90,31,145,31,8,31,191,31,176,31,144,31,144,30,225,31,43,31,43,30,248,31,1,31,90,31,9,31,9,30,27,31,27,30,133,31,133,30,212,31,97,31,133,31,133,30,140,31,117,31,228,31,228,30,166,31,188,31,106,31,127,31,39,31,47,31,47,30,100,31,3,31,3,30,124,31,29,31,91,31,83,31,146,31,230,31,110,31,110,30,81,31,169,31,106,31,104,31,221,31,196,31,65,31,149,31,21,31,77,31,91,31,68,31,155,31,8,31,8,30,8,29,164,31,164,30,254,31,40,31,40,30,124,31,208,31,209,31,224,31,246,31,15,31,51,31,1,31,23,31,22,31,243,31,30,31,176,31,229,31,162,31,25,31,25,30,61,31,61,30,67,31,248,31,69,31,69,30,169,31,169,30,15,31,15,30,7,31,207,31,150,31,150,30,98,31,21,31,33,31,33,30,59,31,85,31,28,31,32,31,127,31,148,31,127,31,210,31,177,31,205,31,133,31,52,31,5,31,148,31,223,31,199,31,213,31,213,30,197,31,233,31,52,31,219,31);

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
